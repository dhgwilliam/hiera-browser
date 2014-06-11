require 'spec_helper'

describe DataDir do
  context 'when initialized with a :path that has unqualified variables' do
    let(:datadir_with_var) { './spec/fixtures/%{environment}/hieradata' }
    let(:subject) { DataDir.new(:path => datadir_with_var) }

    describe '#render_paths' do
      it 'correctly interpolates the variable' do
        expect(subject.paths.first).to eq('./spec/fixtures/production/hieradata')
      end
    end
  end

  context 'when initialized with a :path that has fully qualified variables' do
    let(:datadir_with_var) { './spec/fixtures/%{::environment}/hieradata' }
    let(:subject) { DataDir.new(:path => datadir_with_var) }

    describe '#render_paths' do
      it 'correctly interpolates the variable' do
        expect(subject.paths).to eq(['./spec/fixtures/production/hieradata'])
      end
    end
  end
end

describe DataFile do
  context 'when initialized with a valid path to a hiera yaml datasource' do
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
