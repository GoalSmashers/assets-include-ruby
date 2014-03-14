require_relative 'cache'

module AssetsInclude

  class Base
    attr_accessor :bundled, :asset_hosts, :root, :config, :cache_boosters
    attr_accessor :binary

    def initialize(&block)
      @cache = Cache.new

      yield(self) if block_given?
    end

    def group(locator, options = {})
      assets(locator, options)
    end

    def list(locator)
      assets(locator, list: true)
    end

    def inline(locator)
      assets(locator, inline: true)
    end

    private

    attr_reader :cache

    def assets(locator, options)
      cache.empty unless bundled

      cache.add("#{locator}-#{options.to_s.hash}") do
        IO.popen(command(locator, options).join(' ')).read
      end
    end

    def command(locator, options = {})
      parts = []
      parts << includer_binary
      parts << "-r #{root}"
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
      binary || File.join(root, '..', 'node_modules', '.bin', 'assetsinc')
    end
  end
end
