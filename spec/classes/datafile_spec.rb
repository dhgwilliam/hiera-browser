require 'spec_helper'

describe DataDir do
end

describe DataFile do
  context 'when created with a valid path to a hiera yaml datasource' do
    let(:datafile) { DataFile.new :path => File.join(
      $fixtures_path, 'hieradata', 'common.yaml') }

    describe '#new' do
      it 'has a path' do
        expect(datafile).to respond_to(:path)
        expect(datafile.path).to be_a(String)
        expect(datafile.path).to satisfy { |path|
          File.exist?(path) }
      end
    end

    describe '#keys' do
      it 'returns an array' do
        expect(datafile.keys).to be_an(Array)
      end
    end

  end
end
