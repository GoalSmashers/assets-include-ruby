require 'test_helper'

require 'assets_include/base'

describe AssetsInclude do
  describe '#helpers' do
    it 'should expose AssetsInclude::Base via assets' do
      helpers.assets.is_a?(AssetsInclude::Base).must_equal true
    end

    it 'should correctly apply config variables' do
      helpers.assets.config.must_equal 'test.yml'
    end
  end

  private

  def helpers
    AssetsInclude.helpers { |h|
      h.config = 'test.yml'
    }
  end
end
