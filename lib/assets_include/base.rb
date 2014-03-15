require_relative 'cache'

module AssetsInclude

  class Base
    attr_accessor :bundled, :asset_hosts, :root, :config, :cache_boosters
    attr_accessor :binary

    def initialize(&block)
      @cache = Cache.new
      @config = default_assets_location
      @bundled = production?
      @cache_boosters = true

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
      parts << root_switch
      parts << config_switch
      parts << bundled_switch
      parts << cache_boosters_switch
      parts << list_switch(options)
      parts << inline_switch(options)
      parts << asset_hosts_switch
      parts << loading_mode_switch(options)
      parts << locator
      parts.compact
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

    def root_switch
      root ? "-r #{root}" : nil
    end

    def config_switch
      "-c #{config}"
    end

    def bundled_switch
      bundled ? '-b' : nil
    end

    def cache_boosters_switch
      cache_boosters ? '-s' : nil
    end

    def list_switch(options = {})
      options[:list] ? '-l' : nil
    end

    def inline_switch(options = {})
      options[:inline] ? '-i' : nil
    end

    def asset_hosts_switch
      asset_hosts ? "-a #{asset_hosts}" : nil
    end

    def loading_mode_switch(options = {})
      options[:loading_mode] ? "-m #{options[:loading_mode]}" : nil
    end
  end
end
