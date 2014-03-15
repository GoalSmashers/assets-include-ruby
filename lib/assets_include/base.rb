require_relative 'cache'

module AssetsInclude

  class Base
    attr_accessor :bundled, :asset_hosts, :root, :config, :cache_boosters
    attr_accessor :binary

    def initialize(&block)
      @cache = Cache.new
      @config = default_assets_location
      @bundled = production?

      yield(self) if block_given?
    end

    def group(locator, options = {})
      assets(locator, options)
    end

    def list(locator)
      assets(locator, list: true).strip.split(',')
    end

    def inline(locator)
      assets(locator, inline: true)
    end

    def reset
      cache.empty
    end

    private

    attr_reader :cache

    def assets(locator, options)
      cache.empty unless bundled

      cache.add("#{locator}-#{options.to_s.hash}") do
        IO.popen(command(locator, options).join(' ')).read
      end
    end

    def default_assets_location
      File.join(Dir.pwd, 'assets.yml')
    end

    def production?
      ENV['RACK_ENV'] == 'production'
    end

    def command(locator, options = {})
      parts = []
      parts << includer_binary
      parts << "-r #{root}" if root
      parts << "-c #{config}"
      parts << '-b' if bundled
      parts << '-s' if cache_boosters
      parts << '-l' if options[:list]
      parts << '-i' if options[:inline]
      parts << "-a #{asset_hosts}" if asset_hosts
      parts << "-m #{options[:loading_mode]}" if options[:loading_mode]
      parts << locator
      parts
    end

    def includer_binary
      @binary ||= binary_locations.find { |path|
        IO.popen("which #{path}")
        $?.to_i == 0
      }
    end

    def binary_locations
      [
        File.join(implicit_root, '..', 'node_modules', '.bin', 'assetsinc'),
        File.join(implicit_root, 'node_modules', '.bin', 'assetsinc'),
        'assetsinc'
      ]
    end

    def implicit_root
      root || File.join(Dir.pwd, 'public')
    end
  end
end
