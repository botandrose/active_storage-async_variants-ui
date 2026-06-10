# ActiveStorage::AsyncVariants::UI

The opinionated UI layer for [`active_storage-async_variants`](https://github.com/botandrose/active_storage-async_variants): `image_tag` / `video_tag` rendering with `async:` / `direct:`, a `<turbo-frame>` that polls a processing variant to completion, a circular progress bar (with an error state), and an optional retry affordance — all served through an isolated asset pipeline.

The plumbing gem (`active_storage-async_variants`) is intentionally UI-free: a variant's `.url` serves the original while pending/processing/failed and the processed variant once ready. Add **this** gem when you want the turbo-frame/progress-bar/retry experience on top.

## Installation

```ruby
gem "active_storage-async_variants-ui"
```

This pulls in `active_storage-async_variants` (the plumbing) as a dependency. Run its migrations as documented there:

```bash
bin/rails active_storage_async_variants:install:migrations
bin/rails db:migrate
```

The only other runtime requirement is **Turbo** — the gem depends on `turbo-rails`, which a default Rails app already includes. No manual JS/CSS wiring: the async state partials are self-contained `<turbo-frame>`s and their CSS/JS are served from an isolated asset route.

## `image_tag` / `video_tag` with `async:` and `direct:`

This gem adds two options to `image_tag` and `video_tag`:

```erb
<%# A progress bar while pending/processing, polls for completion,
    swaps to the real image when ready. %>
<%= image_tag user.avatar.variant(:web), async: true %>

<%# When the variant is ready, render its direct CDN/S3 URL instead of
    routing through Rails. While pending/failed, falls back to the
    Rails representation URL (which serves the original). %>
<%= image_tag user.avatar.variant(:web), direct: true %>

<%# Both together: direct URL once processed, progress bar while pending. %>
<%= image_tag user.avatar.variant(:web), async: true, direct: true %>

<%# Same for videos. %>
<%= video_tag user.video.variant(:web), async: true, controls: true %>
```

The first argument must be a `VariantWithRecord` or `Preview` when either option is set; otherwise `image_tag` / `video_tag` behave exactly as in stock Rails.

While a variant is processing, the partial renders a zero-network sized box (a tiny filename-bearing 1x1 GIF, or a source-less `<video>`) with the circular progress bar floating over it — indeterminate until progress is reported, then a determinate percentage that creeps forward between polls. Once a variant permanently fails, the same progress bar renders in its error state (a red ring with an X).

### Configure the direct URL host

By default `direct:` uses the storage service's URL. To serve from a CDN, set the host:

```ruby
# config/initializers/active_storage_async_variants.rb
ActiveStorage::AsyncVariants.cdn_host = "https://d1234abcd.cloudfront.net"
```

The resulting URL is `"#{cdn_host}/#{variant.key}"`.

## Configuration

This gem reopens `ActiveStorage::AsyncVariants`, so its options sit alongside the plumbing gem's in a single `configure` block (each is also a plain accessor):

```ruby
# config/initializers/active_storage_async_variants.rb
ActiveStorage::AsyncVariants.configure do |config|
  config.cdn_host          = "https://d1234abcd.cloudfront.net"
  config.parent_controller = "ApplicationController"
  config.retry_visible_if { current_user&.admin? }
end
```

| Option | Default | Purpose |
|--------|---------|---------|
| `cdn_host` | `nil` | Host for `direct:` URLs (`"#{cdn_host}/#{variant.key}"`); falls back to the storage service URL. |
| `parent_controller` | `"ActionController::Base"` | Base class for the gem's `StatesController`, so the retry view can reach your app's `current_user`. Set as a String. |
| `retry_visible_if` | off | Block (run in the view context) gating the failed-state retry affordance. |

The `heartbeat_interval` (poll cadence) and `heartbeat_stale_after` options live in the plumbing gem; the processing `<turbo-frame>` re-polls at `heartbeat_interval`.

## Retry affordance

When `retry_visible_if` returns truthy, a failed variant reveals (on hover) a control that opens a dialog with the error and a "Retry processing" button. The button destroys the failed `VariantRecord` and re-enqueues the transform via the variant's `#enqueue!`. The dialog's CSS/JS are served as cached assets from `/active_storage/async_variants/assets/…`.

## Overriding the partials

Apps can override any state partial by creating a same-named file in their own `app/views/active_storage/async_variants/states/` (`_processing`, `_processed`, `_failed`, `show`).

## License

MIT
