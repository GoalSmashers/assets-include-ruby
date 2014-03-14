require 'rake/clean'
require 'rake/testtask'
require 'fileutils'

task default: :test
task spec: :test

task :test_setup do
  `cd test/fixtures && npm install && ./node_modules/.bin/assetspkg -c assets.yml`
end

Rake::TestTask.new(test: :test_setup) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.ruby_opts << '-Ilib:test'
  t.warning = true
end

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
