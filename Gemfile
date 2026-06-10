# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# The plumbing gem's split (0.9.0) is unreleased; resolve it from its v0.9.0
# branch so both local dev and CI build against the UI-free plumbing.
gem "active_storage-async_variants",
  git: "https://github.com/botandrose/active_storage-async_variants.git",
  branch: "v0.9.0"

gem "appraisal"
gem "irb"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "simplecov", require: false
gem "rspec-rails"
gem "rails"
gem "sqlite3"

# Browser-level acceptance tests against the dummy app.
gem "cucumber"
gem "capybara"
gem "cuprite"
gem "puma"
