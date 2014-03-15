require_relative 'base'

module AssetsInclude
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
