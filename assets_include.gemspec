$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'assets_include/version'

Gem::Specification.new('assets_include', AssetsInclude::VERSION) do |s|
  s.description = 'Include assets in your views with a single line of code.'
  s.summary = 'Ruby bindings for assets-include node.js library.'
  s.authors = ['Jakub Pawlowicz']
  s.email = 'jakub.pawlowicz@goalsmashers.com'
  s.homepage = 'https://github.com/GoalSmashers/assets-include-ruby'
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n") - %w(.gitignore)
end
