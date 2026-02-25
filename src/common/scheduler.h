/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#pragma once

#include <asio/any_io_executor.hpp>
#include <asio/awaitable.hpp>
#include <asio/co_spawn.hpp>
#include <asio/detached.hpp>
#include <asio/executor_work_guard.hpp>
#include <asio/experimental/awaitable_operators.hpp>
#include <asio/io_context.hpp>
#include <asio/post.hpp>
#include <asio/steady_timer.hpp>
#include <asio/this_coro.hpp>
#include <asio/use_awaitable.hpp>

#include <atomic>
#include <chrono>
#include <concepts>
#include <cstdio>
#include <format>
#include <iostream>
#include <iterator>
#include <memory>
#include <mutex>
#include <stdexcept>
#include <string_view>
#include <thread>
#include <tuple>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

#ifdef TRACY_ENABLE
#include <tracy/Tracy.hpp>
#endif

namespace detail
{

template <typename T>
struct IsASIOAwaitable : std::false_type
{
};

template <typename T, typename E>
struct IsASIOAwaitable<asio::awaitable<T, E>> : std::true_type
{
};

template <typename T>
concept IsAwaitable = IsASIOAwaitable<std::decay_t<T>>::value;

template <typename T>
struct AwaitableResult;

template <typename T, typename E>
struct AwaitableResult<asio::awaitable<T, E>>
{
    using type = T;
};

} // namespace detail

template <typename T>
using Task = asio::awaitable<T, asio::any_io_executor>;

//
// Combinators
//

//
// All
//   Await multiple tasks in parallel and return their results as a tuple.
//
template <typename... Tasks>
    requires(sizeof...(Tasks) > 0)
auto All(Tasks&&... tasks)
{
    using namespace asio::experimental::awaitable_operators;
    return (std::forward<Tasks>(tasks) && ...);
}

//
// One
//   Race multiple tasks and return a variant of the winner.
//
template <typename... Tasks>
    requires(sizeof...(Tasks) > 0)
auto One(Tasks&&... tasks)
{
    using namespace asio::experimental::awaitable_operators;
    return (std::forward<Tasks>(tasks) || ...);
}

//
// Scheduler
//
class Scheduler final
{
public:
    Scheduler(std::size_t numThreads = std::max(1U, std::thread::hardware_concurrency() - 1U))
    : mainContext_()
    , workerContext_()
    , mainGuard_(asio::make_work_guard(mainContext_))
    , workerGuard_(asio::make_work_guard(workerContext_))
    {
#ifdef TRACY_ENABLE
        tracy::SetThreadName("Main Thread");
#endif

        workerThreads_.reserve(numThreads);

        for (size_t i = 0; i < numThreads; ++i)
        {
            workerThreads_.emplace_back(
                [this, i]
                {
#ifdef TRACY_ENABLE
                    const auto threadName = std::format("Worker Thread {}", i + 1);
                    tracy::SetThreadName(threadName.c_str());
#else
                    std::ignore = i;
#endif
                    // Try and do work, but if an exception is encountered capture it and post it back
                    // to the main thread.
                    try
                    {
                        workerContext_.run();
                    }
                    catch (...)
                    {
                        asio::post(
                            mainContext_,
                            [ex = std::current_exception()]
                            {
                                std::rethrow_exception(ex);
                            });
                    }
                });
        }
    }

    ~Scheduler()
    {
        stop();
        for (auto& t : workerThreads_)
        {
            if (t.joinable())
            {
                t.join();
            }
        }
    }

    Scheduler(const Scheduler&)            = delete;
    Scheduler& operator=(const Scheduler&) = delete;
    Scheduler(Scheduler&&)                 = delete;
    Scheduler& operator=(Scheduler&&)      = delete;

    void run()
    {
        isRunning_ = true;

        try
        {
            mainContext_.run(); // block thread
        }
        catch (...)
        {
            stop();
            throw; // Throw exception back up to user
        }

        // Main loop finished. Allow workers to finish their tasks and exit.
        workerGuard_.reset();
        for (auto& t : workerThreads_)
        {
            if (t.joinable())
            {
                t.join();
            }
        }
        isRunning_ = false;
    }

    void stop()
    {
        isRunning_ = false;
        mainGuard_.reset();
        workerGuard_.reset();

        mainContext_.stop();
        workerContext_.stop();
    }

    [[nodiscard]] auto isRunning() const -> bool
    {
        return isRunning_;
    }

    // TODO:
    // Variants of onMainThread/onWorkerThread/postToMainThread/postToWorkerThread that take
    // std::invocable (lambdas, std::bind, etc.)

    // onMainThread
    //   Queue work lazily on the main thread. It won't start executing until you co_await the
    //   returned task.
    template <detail::IsAwaitable T>
    [[nodiscard]] auto onMainThread(T&& task) -> Task<typename detail::AwaitableResult<std::decay_t<T>>::type>
    {
        return asio::co_spawn(mainContext_.get_executor(), std::forward<T>(task), asio::use_awaitable);
    }

    // onWorkerThread
    //   Queue work lazily on the worker thread pool. It won't start executing until you co_await
    //   the returned task.
    template <detail::IsAwaitable T>
    [[nodiscard]] auto onWorkerThread(T&& task) -> Task<typename detail::AwaitableResult<std::decay_t<T>>::type>
    {
        return asio::co_spawn(workerContext_.get_executor(), std::forward<T>(task), asio::use_awaitable);
    }

    // postToMainThread
    //   Queue work eagerly on the main thread. It will start executing immediately.
    template <detail::IsAwaitable T>
    void postToMainThread(T&& task)
    {
        asio::co_spawn(mainContext_.get_executor(), std::forward<T>(task), asio::detached);
    }

    // postToWorkerThread
    //   Queue work eagerly on the worker thread pool. It will start executing immediately.
    template <detail::IsAwaitable T>
    void postToWorkerThread(T&& task)
    {
        asio::co_spawn(workerContext_.get_executor(), std::forward<T>(task), asio::detached);
    }

    // yield
    //   co_await on this to hand control back to the scheduler.
    [[nodiscard]] auto yield() -> Task<void>
    {
        auto executor = co_await asio::this_coro::executor;
        co_await asio::post(executor, asio::use_awaitable);
    }

    // yieldFor
    //   co_await on this to hand control back to the scheduler, without re-scheduling until the
    //   duration has elapsed.
    [[nodiscard]] auto yieldFor(std::chrono::steady_clock::duration duration) -> Task<void>
    {
        auto executor = co_await asio::this_coro::executor;
        auto timer    = asio::steady_timer(executor);
        timer.expires_after(duration);
        co_await timer.async_wait(asio::use_awaitable);
    }

    // ioContext
    //   Return the main io_context.
    //   TODO: We should be trying to get rid of this accessor as soon as possible!
    [[nodiscard]] auto ioContext() -> asio::io_context&
    {
        return mainContext_;
    }

private:
    std::atomic<bool>        isRunning_{ false };
    asio::io_context         mainContext_;
    asio::io_context         workerContext_;
    std::vector<std::thread> workerThreads_;

    asio::executor_work_guard<asio::io_context::executor_type> mainGuard_;
    asio::executor_work_guard<asio::io_context::executor_type> workerGuard_;
};
