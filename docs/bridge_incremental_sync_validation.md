# Bridge incremental sync validation

This checklist verifies that:
1) changing relational tables causes the bridge `date_modified_dtsi` to advance after the next MV refresh, and
2) `GET /api/kithe_bridge?changed_since=...` returns only items changed since that timestamp.

## Prereqs

1. Pick a published document `friendlier_id` with at least one data dictionary entry and/or download entry.
2. You have the bridge refresh task available:
   - `bundle exec rake geoportal:refresh_kithe_to_resources_bridge`

## Step A: Capture the baseline timestamp

1. Record the bridge timestamp for a target document:

```bash
DOC_ID="11b-39003"

curl "http://localhost:4000/api/kithe_bridge/${DOC_ID}?v1=raw" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

2. From the output, note `date_modified_dtsi` (call it `T0`).

## Step B: Change a “missing-callback” related table row

1. Example: update a row in `document_data_dictionary_entries` (the columns include `values`).
2. Any edit should trigger the callback added in `config/initializers/kithe_bridge_change_capture.rb`.

## Step C: Refresh the materialized view

```bash
bundle exec rake geoportal:refresh_kithe_to_resources_bridge
```

## Step D: Verify the bridge timestamp advanced

```bash
curl "http://localhost:4000/api/kithe_bridge/${DOC_ID}?v1=raw" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

Confirm `date_modified_dtsi` is now `> T0`.

## Step E: Verify incremental crawl finds it

```bash
curl "http://localhost:4000/api/kithe_bridge?changed_since=${T0}&limit=50" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

Confirm the response `data[]` includes your `DOC_ID`.

## Notes / gotchas

- If you use cursor pagination, the `cursor` is based on the bridge `id` ordering (friendlier_id strings in this view).
- You must refresh the materialized view for the changes to appear in the API.

