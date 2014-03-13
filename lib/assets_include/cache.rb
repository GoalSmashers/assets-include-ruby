module AssetsInclude
  class Cache
    def initialize
      @store = {}
    end

    def add(key, &block)
      store[key] ||= yield
    end

    def get(key)
      store[key]
    end

    def empty
      store.clear
    end

    private

    attr_reader :store
  end
end
