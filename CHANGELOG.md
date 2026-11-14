## [0.2.0]

- Video previews on the stock preview graph: a video's image variant keeps its record on the extracted-frame blob (`preview_image`), so the state endpoint now rebuilds a `Preview` (via a `repr=preview` param the helper round-trips) and reads state, progress, and the processed URL from there. Format-bearing variations are canonicalized to the declared named variant so a URL-rebuilt digest matches the stored record.
- Retry goes through the representation's `retry!`, so a video preview's failed record on the frame blob is actually replaced; previously the endpoint searched the source blob with the wrong digest and retry silently did nothing for videos.
- Fix: the failed state's retry form now carries `repr`, so retrying a video preview replaces its frame record instead of recording a stray variant on the video blob.
- Requires `active_storage-async_variants` >= 0.10. Hand `image_tag`/`video_tag` a video's `representation(...)` (a `Preview`), not its `variant(...)`, while it is unprocessed.

## [0.1.0]

- Initial release. Extracted from `active_storage-async_variants` (≤ 0.8.0), which now ships the UI-free plumbing. This gem layers on the opinionated UI:
  - `image_tag` / `video_tag` with `async:` and `direct:` (via `AssetTagHelperExtension`).
  - The `<turbo-frame>` state endpoint (`StatesController`) and its `_processing` / `_processed` / `_failed` partials, including the self-polling reload and the filename-bearing 1x1 GIF placeholder route.
  - The circular progress bar (`@botandrose/progress-bar`, with `rate`/`error` states) and the failed-state retry dialog, served through `isolate_assets`.
  - Configuration: `cdn_host`, `parent_controller`, and `retry_visible_if` (reopened onto `ActiveStorage::AsyncVariants`).
- Depends on `active_storage-async_variants` (>= 0.9), `turbo-rails`, and `isolate_assets`. Apps that previously used the full `active_storage-async_variants` for its UI should add this gem.
