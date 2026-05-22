# frozen_string_literal: true

require_relative "lib/asaas/version"

Gem::Specification.new do |spec|
  spec.name    = "asaas-ruby"
  spec.version = Asaas::VERSION
  spec.authors = ["JoaoPierre"]
  spec.email   = ["jppierre90@gmail.com"]

  spec.summary     = "Ruby SDK for the Asaas payment gateway API"
  spec.description = "A Ruby SDK for Asaas — Brazil's payment platform. " \
                     "Supports Customers, Payments (Boleto, Pix, Credit Card), " \
                     "Subscriptions, Webhooks and more."
  spec.homepage    = "https://github.com/JoaoPierre/asaas-ruby"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec",   "~> 3.13"
  spec.add_development_dependency "webmock", "~> 3.23"
  spec.add_development_dependency "vcr",     "~> 6.3"
  spec.add_development_dependency "rubocop", "~> 1.65"
end
