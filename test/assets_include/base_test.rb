require 'test_helper'

require 'assets_include/base'

describe AssetsInclude::Base do
  include FlexMock::TestCase

  def after
    flexmock_teardown

    super
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
        '<link href="/stylesheets/one.css?1394835562000" media="screen" rel="stylesheet"/>',
        '<link href="/stylesheets/two.css?1394835574000" media="screen" rel="stylesheet"/>'
      ]

      includer(bundled: false).group(group).strip.must_equal(assets.join)
    end
  end

  describe '#list' do
    it 'should proxy a call to assetsinc and return correct result' do
      should_run_includer_with(
        options: ['-b', '-l', group],
        output: :list
      )

      includer.list(group).must_equal(:list)
    end

    it 'should do a real call and get a list of assets' do
      assets = [
        '/stylesheets/one.css?1394835562000',
        '/stylesheets/two.css?1394835574000'
      ]

      includer(bundled: false).list(group).strip.must_equal(assets.join(','))
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

  private

  def includer(options = {})
    @includer ||= described_class.new do |inc|
      inc.root = root
      inc.config = config
      inc.bundled = true

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
