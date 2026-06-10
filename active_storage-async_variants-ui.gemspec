# frozen_string_literal: true

require_relative "lib/active_storage/async_variants/ui/version"

Gem::Specification.new do |spec|
  spec.name = "active_storage-async_variants-ui"
  spec.version = ActiveStorage::AsyncVariants::UI::VERSION
  spec.authors = ["Micah Geisel"]
  spec.email = ["micah@botandrose.com"]

  spec.summary = "Turbo-frame UI for active_storage-async_variants: image_tag/video_tag rendering, progress bars, and retry."
  spec.homepage = "https://github.com/botandrose/active_storage-async_variants-ui"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "active_storage-async_variants", ">= 0.9"
  spec.add_dependency "turbo-rails", ">= 2.0"
  spec.add_dependency "isolate_assets", ">= 0.4"
end
