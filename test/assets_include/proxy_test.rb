require 'test_helper'

require 'assets_include/proxy'

describe AssetsInclude::Proxy do
  describe '#module' do
    it 'should be a module' do
      proxy.class.must_equal(Module)
    end

    it 'should be a Proxy module' do
      proxy.is_a?(described_class).must_equal true
    end

    it 'should expose Base via assets' do
      proxy.assets.class.must_equal(AssetsInclude::Base)
    end
  end

  describe 'AssetsInclude.helpers' do
    it 'should yield the Proxy module' do
      AssetsInclude.helpers.is_a?(described_class).must_equal true
    end
  end

  private

  def proxy
    described_class.tap do |p|
      p.assets = AssetsInclude::Base.new
    end
  end

  def described_class
    AssetsInclude::Proxy
  end
end
