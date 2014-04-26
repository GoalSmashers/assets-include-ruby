require 'assets_include/base'
require 'assets_include/proxy'
require 'assets_include/version'

module AssetsInclude
  def self.helpers(&block)
    Proxy.assets = Base.new(&block)
    Proxy
  end
end
