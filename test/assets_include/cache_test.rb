require 'test_helper'

require 'assets_include/cache'

describe AssetsInclude::Cache do
  describe 'initialize' do
    it 'is empty by default' do
      cache.get(:key).must_equal nil
    end
  end

  describe '#add' do
    it 'adds an item to cache' do
      cache.add(:key) { :value }

      cache.get(:key).must_equal :value
    end

    it 'does not overwrite item in cache' do
      2.times do |i|
        cache.add(:key) { i }
      end

      cache.get(:key).must_equal 0
    end
  end

  describe '#get' do
    it 'does not remove item from cache' do
      cache.add(:key) { :value }

      cache.get(:key).must_equal :value
      cache.get(:key).must_equal :value
    end
  end

  describe '#empty' do
    it 'empties the cache' do
      cache.add(:key) { :value }

      cache.empty
      cache.get(:key).must_equal nil
    end
  end

  private

  def cache
    @cache ||= described_class.new
  end

  def described_class
    AssetsInclude::Cache
  end
end
