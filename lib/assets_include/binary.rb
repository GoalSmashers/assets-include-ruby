module AssetsInclude
  class Binary < Struct.new(:root)
    def location
      binary_locations.find { |path|
        IO.popen("which #{path}")
        $?.to_i == 0
      }
    end

    private

    def binary_locations
      [
        File.join(root, '..', 'node_modules', '.bin', 'assetsinc'),
        File.join(root, 'node_modules', '.bin', 'assetsinc'),
        'assetsinc'
      ]
    end
  end
end
