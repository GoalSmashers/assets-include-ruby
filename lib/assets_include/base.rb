require_relative 'cache'

module AssetsInclude

  class Base
    attr_accessor :bundled, :asset_hosts, :root, :config, :cache_boosters

    def initialize(&block)
      @cache = Cache.new

      yield(self) if block_given?
    end

    def group(locator, options = {})
      cache.empty unless bundled

      cache.add("#{locator}-#{options.to_s.hash}") do
        run(*command(locator, options))
      end
    end

    private

    attr_reader :cache

    def run(*args)
      IO.popen(args).read
    end

    def command(locator, options = {})
      parts = []
      parts << binary
      parts << "-r #{root}"
      parts << "-c #{config}"
      parts << '-b' if bundled
      parts << '-s' if cache_boosters
      parts << "-a #{asset_hosts}" if asset_hosts
      parts << "-m #{options[:loading_mode]}" if options[:loading_mode]
      parts << locator
      parts
    end

    def binary
      './node_modules/.bin/assetsinc'
    end
  end
end
