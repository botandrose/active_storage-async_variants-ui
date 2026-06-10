# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# The plumbing gem lives next door and is unreleased at the split version;
# resolve it from the sibling checkout rather than rubygems.
gem "active_storage-async_variants", path: "../active_storage-async_variants"

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
