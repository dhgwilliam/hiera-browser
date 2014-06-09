require 'spec_helper'

describe Node do
  context 'when YAML_DIR is set by ENV' do
    let(:node) { Node.new(:certname => 'agent') }

    describe '#node_dir' do
      it 'matches the YAML_DIR envvar' do
        expect(node.node_dir).to match(/yaml\/node$/)
      end
    end

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

    describe '.files' do
      it 'should return an array' do
        expect(Node.files).to be_an(Array)
      end

      it 'should include agent.yaml' do
        expect(Node.files).to include("agent.yaml")
      end
    end

    describe '.list' do
      it 'should return an array' do
        expect(Node.list).to be_an(Array)
      end

      it 'should include agent' do
        expect(Node.list).to include("agent")
      end
    end

    describe '.parameters' do
      it 'should return a hash' do
        expect(Node.parameters).to be_a(Hash)
      end

      it 'should include datacenter and environment' do
        expect(Node.parameters).to include("datacenter")
        expect(Node.parameters).to include("environment")
      end
    end

    describe '.environments' do
      it 'should return an array of environments' do
        expect(Node.environments).to be_an(Array)
      end

      it 'should include "production"' do
        expect(Node.environments).to include('production')
      end
    end
  end
end
