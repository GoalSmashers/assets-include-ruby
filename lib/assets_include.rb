require 'assets_include/base'
require 'assets_include/proxy'
require 'assets_include/version'

module AssetsInclude
  def self.helpers(options = {})
    Proxy.assets = Base.new(options)
    Proxy
  end
end
