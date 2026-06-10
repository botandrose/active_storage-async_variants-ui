## [0.1.0]

- Initial release. Extracted from `active_storage-async_variants` (≤ 0.8.0), which now ships the UI-free plumbing. This gem layers on the opinionated UI:
  - `image_tag` / `video_tag` with `async:` and `direct:` (via `AssetTagHelperExtension`).
  - The `<turbo-frame>` state endpoint (`StatesController`) and its `_processing` / `_processed` / `_failed` partials, including the self-polling reload and the filename-bearing 1x1 GIF placeholder route.
  - The circular progress bar (`@botandrose/progress-bar`, with `rate`/`error` states) and the failed-state retry dialog, served through `isolate_assets`.
  - Configuration: `cdn_host`, `parent_controller`, and `retry_visible_if` (reopened onto `ActiveStorage::AsyncVariants`).
- Depends on `active_storage-async_variants` (>= 0.9), `turbo-rails`, and `isolate_assets`. Apps that previously used the full `active_storage-async_variants` for its UI should add this gem.
