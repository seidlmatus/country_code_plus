# Country data provenance

`lib/src/codes.dart` contains committed country records based on ISO 3166-1
alpha-2/alpha-3 assignments, Unicode CLDR territory names and likely-subtag
locale behavior, and authoritative international calling-code assignments.
`XK` is retained as a documented user-assigned Kosovo entry for backwards
compatibility; it is not counted among the 249 officially assigned ISO codes.

`lib/src/subdivisions.dart` is committed ISO 3166-2 data refreshed from the
`iso3166-2` dataset used by this project. The checked-in data is the runtime
source, so package users do not need a network connection or a generator.

When refreshing data, update the generated files, review names/calling codes,
run the completeness and subdivision tests, and record the refresh date and
source version in the release notes. The integrity test intentionally checks
the full ISO alpha-2 set so missing entries such as `AX` or `SZ` fail loudly.

Last refreshed for 5.2.0: 2026-08-30.
