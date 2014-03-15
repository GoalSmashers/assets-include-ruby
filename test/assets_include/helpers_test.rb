require 'test_helper'

require 'assets_include/helpers'

describe AssetsInclude::Helpers do
  describe '#configure' do
    it 'should yield a Proxy module' do
      helpers.class.must_equal(Module)
    end

    it 'should expose Base via assets' do
      helpers.assets.class.must_equal(AssetsInclude::Base)
    end
  end

  private

  def helpers(&block)
    described_class.configure(&block)
  end

  def described_class
    AssetsInclude::Helpers
  end
end
