# Bridge incremental sync validation

This checklist verifies that:
1) changing a Bridge-exported nested collection advances the resource-level Bridge watermark,
2) `GET /api/kithe_bridge?changed_since=...` returns the resource after the next MV refresh, and
3) nested and document deletions are visible to incremental consumers.

## Prereqs

1. Pick a published document `friendlier_id` with at least one exported nested record. The covered collections are
   data dictionaries, data dictionary entries, distributions, downloads, licensed accesses, and assets.
2. You have the bridge refresh task available:
   - `bundle exec rake geoportal:refresh_kithe_to_resources_bridge`

## Step A: Capture the baseline timestamp

1. Record the bridge timestamp for a target document:

```bash
DOC_ID="11b-39003"

curl "http://localhost:4000/api/kithe_bridge/${DOC_ID}?v1=raw" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

2. From the output, note `kithe_updated_at` (call it `T0`).

## Step B: Change an exported nested row

1. Create, update, or delete a row in one of the covered nested collections. For example, add a
   `document_distribution` after the parent document was last modified.
2. The mutation should advance `kithe_models.bridge_updated_at` in the same transaction.

## Step C: Refresh the materialized view

```bash
bundle exec rake geoportal:refresh_kithe_to_resources_bridge
```

## Step D: Verify the bridge timestamp advanced

```bash
curl "http://localhost:4000/api/kithe_bridge/${DOC_ID}?v1=raw" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

Confirm `kithe_updated_at` is now `> T0`.

## Step E: Verify incremental crawl finds it

```bash
curl "http://localhost:4000/api/kithe_bridge?changed_since=${T0}&limit=50" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

Confirm the response `data[]` includes your `DOC_ID`.

## Step F: Verify nested deletions are emitted on the next refresh

1. Delete an exported nested record, such as a `document_distribution`.
2. Refresh the materialized view and repeat the incremental crawl from Step E.
3. Confirm the parent document appears and the serialized collection reflects the deletion.

## Step G: Verify document deletions are emitted on the next refresh

1. Delete a target document in the admin UI or with `document.destroy`.
2. Refresh the materialized view:

```bash
bundle exec rake geoportal:refresh_kithe_to_resources_bridge
```

3. Re-run the incremental crawl:

```bash
curl "http://localhost:4000/api/kithe_bridge?changed_since=${T0}&limit=50" \
  -H "X-Bridge-Token: <KITHE_BRIDGE_TOKEN>"
```

Confirm the deleted document appears once with `"deleted": true` and a `deleted_at` timestamp.

## Notes / gotchas

- If you use cursor pagination, the `cursor` is based on the bridge `id` ordering (friendlier_id strings in this view).
- You must refresh the materialized view for the changes to appear in the API.
- Full bridge dumps continue to exclude deleted rows unless the caller passes `include_deleted=true`.
