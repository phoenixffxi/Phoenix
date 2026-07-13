set(PHOENIX_ECONOMY_RUNTIME_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_correlator.h"
    "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_event.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_event.h"
    "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_module.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_producer.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_producer.h"
)

# modules/init.txt includes this file after xi_map exists. Keeping the source
# list explicit prevents the standalone .cc harness from entering xi_map.
if(TARGET xi_map)
    target_sources(xi_map PRIVATE ${PHOENIX_ECONOMY_RUNTIME_SOURCES})
    target_include_directories(xi_map PRIVATE "${CMAKE_CURRENT_LIST_DIR}/cpp")

    option(PHOENIX_ECONOMY_BUILD_TESTS "Build the Phoenix economy module harness" OFF)
    if(PHOENIX_ECONOMY_BUILD_TESTS)
        include(CTest)
        find_package(Python3 REQUIRED COMPONENTS Interpreter)
        add_executable(economy_producer_harness EXCLUDE_FROM_ALL
            "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_event.cpp"
            "${CMAKE_CURRENT_LIST_DIR}/cpp/economy_producer.cpp"
            "${CMAKE_CURRENT_LIST_DIR}/tests/economy_producer_harness.cc"
        )
        target_compile_features(economy_producer_harness PRIVATE cxx_std_23)
        target_compile_definitions(economy_producer_harness PRIVATE PHOENIX_ECONOMY_TESTING=1)
        target_include_directories(economy_producer_harness PRIVATE
            "${CMAKE_CURRENT_LIST_DIR}/cpp"
            "${CMAKE_SOURCE_DIR}/ext/concurrentqueue/concurrentqueue"
        )
        target_link_libraries(economy_producer_harness PRIVATE
            Threads::Threads
            ZLIB::ZLIB
            ${OpenSSLlibcrypto_LIBRARY}
            project_options
            project_warnings
        )
        add_executable(economy_correlator_harness EXCLUDE_FROM_ALL
            "${CMAKE_CURRENT_LIST_DIR}/tests/economy_correlator_harness.cc"
        )
        target_compile_features(economy_correlator_harness PRIVATE cxx_std_23)
        target_include_directories(economy_correlator_harness PRIVATE "${CMAKE_CURRENT_LIST_DIR}/cpp")
        target_link_libraries(economy_correlator_harness PRIVATE project_options project_warnings)
        add_test(
            NAME economy_spool_contract
            COMMAND "${Python3_EXECUTABLE}" "${CMAKE_CURRENT_LIST_DIR}/tests/test_spool_contract.py"
                    --harness "$<TARGET_FILE:economy_producer_harness>"
        )
        add_test(NAME economy_correlator_contract COMMAND economy_correlator_harness)

        find_program(PHOENIX_LUAJIT_EXECUTABLE NAMES luajit)
        if(PHOENIX_LUAJIT_EXECUTABLE)
            add_test(
                NAME economy_lua_override_contract
                COMMAND "${PHOENIX_LUAJIT_EXECUTABLE}"
                        "${CMAKE_CURRENT_LIST_DIR}/tests/test_lua_overrides.luatest"
                        "${CMAKE_CURRENT_LIST_DIR}/lua/economy_telemetry.lua"
            )
            set_tests_properties(economy_lua_override_contract PROPERTIES
                ENVIRONMENT "PHOENIX_ECONOMY_TELEMETRY_ENABLED=true"
            )
        endif()
    endif()
    return()
endif()

# Standalone producer test project. This path exercises production sources
# without configuring or linking the full game server.
cmake_minimum_required(VERSION 3.20)
project(phoenix_economy_producer_tests LANGUAGES C CXX)

include(CTest)
include(FetchContent)
find_package(Threads REQUIRED)
find_package(Python3 REQUIRED COMPONENTS Interpreter)

get_filename_component(PHOENIX_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)

if(WIN32 AND EXISTS "${PHOENIX_ROOT}/ext/openssl/lib64/libcrypto.lib")
    add_library(phoenix_test_crypto STATIC IMPORTED)
    set_target_properties(phoenix_test_crypto PROPERTIES
        IMPORTED_LOCATION "${PHOENIX_ROOT}/ext/openssl/lib64/libcrypto.lib"
        INTERFACE_INCLUDE_DIRECTORIES "${PHOENIX_ROOT}/ext/openssl/include"
    )
else()
    find_package(OpenSSL REQUIRED COMPONENTS Crypto)
    add_library(phoenix_test_crypto ALIAS OpenSSL::Crypto)
endif()

find_package(ZLIB QUIET)
if(NOT TARGET ZLIB::ZLIB)
    set(ZLIB_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    FetchContent_Declare(
        economy_test_zlib
        GIT_REPOSITORY https://github.com/madler/zlib.git
        GIT_TAG v1.3.1
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(economy_test_zlib)
    if(TARGET zlibstatic)
        add_library(ZLIB::ZLIB ALIAS zlibstatic)
    else()
        add_library(ZLIB::ZLIB ALIAS zlib)
    endif()
endif()

add_executable(economy_producer_harness
    cpp/economy_event.cpp
    cpp/economy_producer.cpp
    tests/economy_producer_harness.cc
)
add_executable(economy_correlator_harness
    tests/economy_correlator_harness.cc
)
target_compile_features(economy_producer_harness PRIVATE cxx_std_23)
target_compile_features(economy_correlator_harness PRIVATE cxx_std_23)
target_compile_definitions(economy_producer_harness PRIVATE PHOENIX_ECONOMY_TESTING=1)
target_include_directories(economy_producer_harness PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/cpp"
    "${PHOENIX_ROOT}/ext/concurrentqueue/concurrentqueue"
)
target_include_directories(economy_correlator_harness PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/cpp"
)
target_link_libraries(economy_producer_harness PRIVATE
    Threads::Threads
    ZLIB::ZLIB
    phoenix_test_crypto
)
if(MSVC)
    target_compile_definitions(economy_producer_harness PRIVATE _CRT_SECURE_NO_WARNINGS)
    target_compile_options(economy_producer_harness PRIVATE /W4 /WX /permissive- /wd4554)
    target_compile_options(economy_correlator_harness PRIVATE /W4 /WX /permissive-)
else()
    target_compile_options(economy_producer_harness PRIVATE -Wall -Wextra -Werror)
    target_compile_options(economy_correlator_harness PRIVATE -Wall -Wextra -Werror)
endif()

add_test(
    NAME economy_spool_contract
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_CURRENT_LIST_DIR}/tests/test_spool_contract.py"
            --harness "$<TARGET_FILE:economy_producer_harness>"
)
add_test(NAME economy_correlator_contract COMMAND economy_correlator_harness)

find_program(PHOENIX_LUAJIT_EXECUTABLE NAMES luajit)
if(PHOENIX_LUAJIT_EXECUTABLE)
    add_test(
        NAME economy_lua_override_contract
        COMMAND "${PHOENIX_LUAJIT_EXECUTABLE}"
                "${CMAKE_CURRENT_LIST_DIR}/tests/test_lua_overrides.luatest"
                "${CMAKE_CURRENT_LIST_DIR}/lua/economy_telemetry.lua"
    )
    set_tests_properties(economy_lua_override_contract PROPERTIES
        ENVIRONMENT "PHOENIX_ECONOMY_TELEMETRY_ENABLED=true"
    )
endif()
