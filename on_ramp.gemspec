require_relative 'lib/on_ramp/version'

Gem::Specification.new do |spec|
  spec.name = 'on_ramp'
  spec.version = OnRamp::VERSION
  spec.authors = ['Tyler Schneider']
  spec.email = ['tylercschneider@gmail.com']

  spec.summary = 'A flexible onboarding engine for Rails applications'
  spec.description = 'OnRamp provides a DSL for defining multi-step onboarding flows with conditional branching, progress tracking, and callbacks.'
  spec.homepage = 'https://github.com/tylercschneider/on_ramp'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    Dir['{app,config,db,lib}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md', 'CHANGELOG.md']
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 7.0'
end
