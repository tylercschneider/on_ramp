require_relative "lib/onramp/version"

Gem::Specification.new do |spec|
  spec.name = "onramp"
  spec.version = Onramp::VERSION
  spec.authors = ["Tyler Schneider"]
  spec.email = ["tyler@example.com"]

  spec.summary = "A flexible onboarding engine for Rails applications"
  spec.description = "Onramp provides a DSL for defining multi-step onboarding flows with conditional branching, progress tracking, and callbacks."
  spec.homepage = "https://github.com/tylercschneider/onramp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md", "CHANGELOG.md"]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0"
end
