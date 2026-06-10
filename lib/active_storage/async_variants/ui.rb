# frozen_string_literal: true

require "active_storage/async_variants"   # the plumbing gem
require "turbo-rails"
require "isolate_assets"
require_relative "ui/version"
require_relative "helper"
require_relative "asset_tag_helper_extension"

module ActiveStorage
  module AsyncVariants
    # HTML attributes round-tripped through the state-endpoint URL so the
    # eventual processed-state render can apply them to the inner <img>/<video>.
    PASS_THROUGH_HTML_OPTIONS = %i[alt width height controls autoplay preload].freeze

    mattr_accessor :cdn_host
    mattr_accessor :retry_visible_proc, default: ->(_view) { false }

    # Lets the host app plug its auth chain (and thus `current_user`) into the
    # gem's StatesController. Set to a string so resolution is deferred until
    # the host's class is autoloadable. Defaults to ActionController::Base.
    mattr_accessor :parent_controller, default: "ActionController::Base"

    # Gates the failed-state retry affordance; the block runs in the view context.
    def self.retry_visible_if(&block)
      self.retry_visible_proc = block
    end

    def self.retry_visible?(view)
      !!view.instance_exec(&retry_visible_proc)
    rescue StandardError
      false
    end

    class UIEngine < ::Rails::Engine
      config.after_initialize do
        ActionView::Helpers::AssetTagHelper.prepend(
          ActiveStorage::AsyncVariants::AssetTagHelperExtension
        )
      end
    end

    Assets = IsolateAssets.register(namespace: self, engine: UIEngine, route_name: :async_variant_asset)
  end
end
