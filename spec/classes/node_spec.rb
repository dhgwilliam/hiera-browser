require 'spec_helper'

describe Node do
  context 'when YAML_DIR is set by ENV' do
    let(:node) { Node.new(:certname => 'agent') }

    describe '#certname' do
      it 'matches agent' do
        expect(node.certname).to match('agent')
      end
    end

    describe '#facts_yaml' do
      it 'includes "datacenter" fact' do
        expect(node.facts_yaml).to include('datacenter' => 'pdx')
      end
    end

    describe '#parameters' do
      it 'includes "datacenter" fact' do
        expect(node.parameters).to include('datacenter' => 'pdx')
      end
    end

  end


  context 'when initialized with a :node_dir' do
    let(:subject) { Node.new(:certname => 'agent', 
                             :node_dir => File.join($fixtures_path, 'yaml/node') ) }
    describe '#node_dir' do
      it 'matches the passed :node_dir' do
        expect(subject.node_dir.path).to eq(File.join($fixtures_path, 'yaml/node'))
      end
    end
  end
end

describe YamlDir do
  context 'when initialized without a :node_dir' do
    let(:subject) { YamlDir.new }

    describe '#files' do
      it 'should return an array' do
        expect(subject.files).to be_an(Array)
      end

      it 'should include agent.yaml' do
        expect(subject.files).to include("agent.yaml")
      end
    end

    describe '#list' do
      it 'should return an array' do
        expect(subject.list).to be_an(Array)
      end

      it 'should include agent' do
        expect(subject.list).to include("agent")
      end
    end

    describe '#parameters' do
      it 'should return a hash' do
        expect(subject.parameters).to be_a(Hash)
      end

      it 'should include datacenter and environment' do
        expect(subject.parameters).to include("datacenter")
        expect(subject.parameters).to include("environment")
      end
    end

    describe '#environments' do
      it 'should return an array of environments' do
        expect(subject.environments).to be_an(Array)
      end

      it 'should include "production"' do
        expect(subject.environments).to include('production')
      end
    end
  end
end
