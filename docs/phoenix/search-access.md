# Auction-house search access

Phoenix requires a live game session from the TCP peer's IP before answering
auction-house listing or history requests. The session must belong to an account
with the normal-login bit set and the banned bit clear. This lookup runs for every
AH request, including requests on an existing connection. Database lookup failures
deny access. An IP in `search.ACCESS_WHITELIST` still needs a live allowed session.

`search.AH_REQUESTS_PER_ACCOUNT_PER_MINUTE` defaults to 120. The request budget is
shared across all search connections from an IP and scales with the number of
live, allowed accounts at that IP. Listing, pagination, single-history and stack-
history requests share the budget. A window starts with its first request and
resets after one minute. Zero denies AH requests. Expired IP windows are removed
periodically. Other search packet types retain their existing behavior.

The legacy search protocol does not bind AH requests to a particular account.
This check establishes eligibility for the source IP, rather than authenticating
an individual caller behind a shared IP. A collector with an allowed live session
can still collect data within its request budget. HTTP API permissions and account
moderation remain separate controls.

Before rollout, check normal AH category browsing, single and stack history,
multiple clients sharing an IP, and `/sea`. Verify that logging out or banning the
last allowed account ends AH access on a connection that was already open.

The `[search][ah-access]` Catch2 cases cover request budgets. The packet-level
regression check uses a built `xi_search` and the adjacent Platform test fixture:

```sh
COMPOSE_PROJECT_NAME=phoenix-search-ah-test PHOENIX_TEST_MARIADB_PORT=3308 \
  docker compose -f ../phoenix-platform/apps/api/docker-compose.test.yml up -d --wait mariadb-test
python tools/ci/test_search_ah_access.py
COMPOSE_PROJECT_NAME=phoenix-search-ah-test PHOENIX_TEST_MARIADB_PORT=3308 \
  docker compose -f ../phoenix-platform/apps/api/docker-compose.test.yml down
```

This check resets sessions only in that dedicated test container, starts its own
search process on a free port, and exercises real encrypted requests. It covers
anonymous callers, account status bits, the game's IP encoding, bans/logout on
open sockets, shared-IP limits, reconnects, all AH packet types, and failed DB
lookups. No retail or player-client capture is used by this test.
