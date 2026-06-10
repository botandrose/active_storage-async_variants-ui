# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

The opinionated UI layer for `active_storage-async_variants` (the plumbing gem, a sibling checkout at `../active_storage-async_variants`). The plumbing gem is UI-free; this gem adds `image_tag`/`video_tag` rendering, a `<turbo-frame>` state endpoint, a circular progress bar, and a retry affordance. It reopens `ActiveStorage::AsyncVariants` (rather than introducing a new namespace) but defines its own engine class, `ActiveStorage::AsyncVariants::UIEngine`, since two engines can't share a class.

## Commands

```bash
bundle exec rake          # rspec + cucumber (default task is :all)
bundle exec rspec         # Run all specs
bundle exec cucumber features/state_rendering.feature  # one browser feature
```

The `Gemfile` resolves the plumbing gem from `../active_storage-async_variants` via a path override, so local changes there are picked up without a release.

## Architecture

Loaded via `lib/active_storage/async_variants/ui.rb`, which requires the plumbing gem first, then:

- **`AssetTagHelperExtension`** → prepended onto `ActionView::Helpers::AssetTagHelper` — adds `async:`/`direct:` to `image_tag`/`video_tag`; routes unprocessed variants through a `<turbo-frame>`.
- **`Helper`** — shared view/controller helpers (frame id/src, resolved src, placeholder tag).
- **`StatesController`** (`app/controllers/...`) — renders `_processing`/`_processed`/`_failed` partials at `GET /active_storage/async_variants/states/:signed_blob_id/:variation_key`, plus a `retry` action and a filename-bearing 1x1 GIF `placeholder` action. Its parent class is `ActiveStorage::AsyncVariants.parent_controller`.
- **Assets** — `progress-bar.js` / `retry.js` / `progress.css` / `retry.css` served via `isolate_assets` (`Assets.draw` in `config/routes.rb`).
- **Config** — `cdn_host`, `parent_controller`, `retry_visible_if`, `PASS_THROUGH_HTML_OPTIONS` (defined in `ui.rb`, reopening `ActiveStorage::AsyncVariants`).

The state machine, `ProcessJob`, callbacks endpoint, `Transformer`, and `VariantRecord` columns all live in the plumbing gem.

## Testing

- RSpec specs in `spec/active_storage/` (view helpers, states controller, configuration) + browser-level cucumber features in `features/` (capybara + cuprite against `spec/dummy`).
- SQLite in-memory schema in `spec/support/schema.rb`; `minimum_coverage 100` is enforced over this gem's `lib`.
- Jobs use the `:test` queue adapter.
