require 'spec_helper'

describe YamlDir do
  context 'when initialized with a :node_dir that doesn\'t exist' do
    let(:node_dir) { File.join($fixtures_path, 'yaml/nodes') }

    let(:subject) { YamlDir.new :node_dir => File.join( node_dir) }

    it 'raises an ENOENT error' do
      expect { subject }.to raise_error
    end

  end

  context 'when initialized with a :node_dir that exists' do
    let(:node_dir) { File.join($fixtures_path, 'yaml/node') }

    let(:subject) { YamlDir.new :node_dir => File.join( node_dir) }

    describe '#path' do
      it 'matches the :node_dir that was passed' do
        expect(subject.path).to eq(ENV['YAML_DIR'])
      end
    end
  end

  context 'when initialized without a :node_dir' do
    let(:subject) { YamlDir.new }

    describe '#path' do
      it 'matches the YAML_DIR envvar' do
        expect(subject.path).to eq(ENV['YAML_DIR'])
      end
    end

    describe '#files' do
      it 'returns an array' do
        expect(subject.file_list).to be_an(Array)
      end

      it 'includes agent.yaml' do
        expect(subject.file_list).to include("agent.yaml")
      end
    end

    describe '#list' do
      it 'returns an array' do
        expect(subject.node_list).to be_an(Array)
      end

      it 'includes "agent"' do
        expect(subject.node_list).to include("agent")
      end
    end

    describe '#parameters' do
      it 'returns a hash' do
        expect(subject.parameters).to be_a(Hash)
      end

      it 'includes datacenter and environment' do
        expect(subject.parameters).to include("datacenter")
        expect(subject.parameters).to include("environment")
      end
    end

    describe '#environments' do
      it 'returns an array of environments' do
        expect(subject.environments).to be_an(Array)
      end

      it 'includes "production"' do
        expect(subject.environments).to include('production')
      end
    end
  end
end
