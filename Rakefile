require 'rake/clean'
require 'fileutils'

if defined?(Gem)
  directory('pkg/')

  def spec
    require 'rubygems' unless defined? Gem::Specification
    @spec ||= eval(File.read('assets_include.gemspec'))
  end

  def package
    %{pkg/assets_include-#{spec.version}.gem}
  end

  desc 'Build packages'
  task package: package

  desc 'Build and install as a local gem'
  task install: package do
    sh %{gem install #{package}}
  end

  file package => %w[pkg/ assets_include.gemspec] do |f|
    sh 'gem build assets_include.gemspec'
    mv File.basename(f.name), f.name
  end
end
