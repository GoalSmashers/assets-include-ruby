require 'test_helper'

require 'assets_include/base'

describe AssetsInclude::Base do
  include FlexMock::TestCase

  def after
    flexmock_teardown

    super
  end

  describe '#initialize' do
    it 'should make binary customizable' do
      flexmock(IO)
        .should_receive(:popen)
        .once
        .with(['assetsinc', "-r #{root}", "-c #{config}", '-b', group].join(' '))
        .and_return(flexmock(read: ''))

      includer(binary: 'assetsinc').group(group)
    end

    it 'should default `root` and `config`' do
      flexmock(IO)
        .should_receive(:popen)
        .once
        .with([binary, "-c #{File.join(Dir.pwd, 'assets.yml')}", group].join(' '))
        .and_return(flexmock(read: ''))

      described_class.new { |inc|
        inc.binary = binary
      }.group(group)
    end

    it 'should set `bundled` to false by default' do
      described_class.new.bundled.must_equal false
    end

    it 'should set `bundled` to true on production' do
      begin
        ENV['RACK_ENV'] = 'production'

        described_class.new.bundled.must_equal true
      ensure
        ENV['RACK_ENV'] = 'test'
      end
    end
  end

  describe '#group' do
    it 'should proxy a call to assetsinc and return correct result' do
      should_run_includer_with(options: ['-b', group])

      includer.group(group).must_equal(:assets)
    end

    it 'should cache any subsequent calls' do
      should_run_includer_with(options: ['-b', group])

      includer.group(group)
      includer.group(group).must_equal(:assets)
    end

    it 'should cache results based on passed locator' do
      should_run_includer_with(
        options: ['-b', group],
        output: :assets_1
      )

      should_run_includer_with(
        options: ['-b', group('page')],
        output: :assets_2
      )

      includer.group(group).must_equal(:assets_1)
      includer.group(group('page')).must_equal(:assets_2)
    end

    it 'should empty cache if not bundled' do
      should_run_includer_with(
        options: [group],
        repeat: 2
      )

      2.times do
        includer(bundled: false).group(group)
      end
    end

    it 'should use cache boosters' do
      should_run_includer_with(options: ['-b', '-s', group])

      includer(cache_boosters: true).group(group)
    end

    it 'should use asset hosts' do
      should_run_includer_with(options: ['-b', '-a goalsmashers.com', group])

      includer(asset_hosts: 'goalsmashers.com').group(group)
    end

    it 'should use loading mode' do
      should_run_includer_with(options: ['-b', '-m async', group])

      includer.group(group, loading_mode: 'async')
    end

    it 'should do a real call and get a list of tags' do
      assets = [
        %{<link href="#{file_with_timestamp('one.css')}" media="screen" rel="stylesheet"/>},
        %{<link href="#{file_with_timestamp('two.css')}" media="screen" rel="stylesheet"/>}
      ]

      includer(bundled: false).group(group).strip.must_equal(assets.join)
    end
  end

  describe '#list' do
    it 'should proxy a call to assetsinc and return correct result' do
      should_run_includer_with(
        options: ['-b', '-l', group],
        output: 'list'
      )

      includer.list(group).must_equal(['list'])
    end

    it 'should do a real call and get a list of assets' do
      assets = [
        file_with_timestamp('one.css'),
        file_with_timestamp('two.css')
      ]

      includer(bundled: false).list(group).must_equal(assets)
    end
  end

  describe '#inline' do
    it 'should proxy a call to assetsinc and return correct result' do
      should_run_includer_with(
        options: ['-b', '-i', group],
        output: :inline
      )

      includer.inline(group).must_equal(:inline)
    end

    it 'should do a real call and get an inline style' do
      inline = '<style type="text/css">.one,.two{color:red}</style>'

      includer(bundled: true).inline(group).strip.must_equal(inline)
    end
  end

  describe '#reset' do
    it 'should empty cache' do
      should_run_includer_with(
        options: ['-b', group],
        repeat: 2
      )

      includer.group(group)
      includer.reset
      includer.group(group)
    end
  end

  private

  def includer(options = {})
    @includer ||= described_class.new do |inc|
      inc.root = root
      inc.config = config
      inc.bundled = true
      inc.binary = binary

      options.each do |key, value|
        inc.public_send("#{key}=", value)
      end
    end
  end

  def should_run_includer_with(opts = {})
    flexmock(IO)
      .should_receive(:popen)
      .times(opts[:repeat] || 1)
      .with(([binary, "-r #{root}", "-c #{config}"] + opts[:options]).join(' '))
      .and_return(flexmock(read: opts[:output] || :assets))
  end

  def file_with_timestamp(name)
    local_path = File.join('stylesheets', name)
    absolute_path = File.join(root, local_path)
    relative_path = absolute_path.sub(root, '')

    "#{relative_path}?#{File.mtime(absolute_path).to_i * 1000}"
  end

  def group(name = 'all')
    "stylesheets/#{name}.css"
  end

  def binary
    File.join(root, '..', 'node_modules', '.bin', 'assetsinc')
  end

  def root
    File.join(Dir.pwd, 'test', 'fixtures', 'public')
  end

  def config
    File.join(root, '..', 'assets.yml')
  end

  def described_class
    AssetsInclude::Base
  end
end
