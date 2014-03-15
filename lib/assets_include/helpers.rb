require_relative 'base'

module AssetsInclude
  class Helpers
    def self.configure(&block)
      Proxy.assets = Base.new(&block)
      Proxy
    end
  end

  module Proxy
    extend self

    def assets=(includer)
      @@includer = includer
    end

    def assets
      @@includer
    end
  end
end
