require 'assets_include/base'
require 'assets_include/proxy'
require 'assets_include/version'

module AssetsInclude
  def self.helpers(*args)
    Proxy.assets = Base.new(*args)
    Proxy
  end
end
