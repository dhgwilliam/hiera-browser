require 'spec_helper'

describe Node do
  context 'when initialized without a :node_dir' do
    let(:subject) { Node.new(:certname => 'agent') }

    describe '#certname' do
      it 'matches agent' do
        expect(subject.certname).to match('agent')
      end
    end

    describe '#facts_yaml' do
      it 'includes "datacenter" fact' do
        expect(subject.facts_yaml).to include('datacenter' => 'pdx')
      end
    end

    describe '#parameters' do
      it 'includes "datacenter" fact' do
        expect(subject.parameters).to include(Parameter.new :key => 'datacenter', :value => 'pdx')
      end
    end

    describe '#hiera_values' do
      it 'returns a Hash of keys and values' do
        expect(subject.hiera_values).to be_a(Hash)
        expect(subject.hiera_values).to eq({
          "test_array"=>["array value 1 from pdx.yaml", "array value 2 from pdx.yaml", "array value 3 from pdx.yaml"], 
          "test_bool"=>false, 
          "test_hash"=>{"test_hash_key1"=>"test_hash_key1 value from pdx.yaml", "test_hash_key2"=>"test_hash_key2 value from pdx.yaml", "test_hash_key3"=>"test_hash_key3 value from pdx.yaml", "test_hash_merge_pdx"=>"test_hash_merge_key from pdx.yaml"}, 
          "test_string"=>"test_string value from pdx.yaml"
        })
      end
    end

    describe '#sorted_values' do
      it 'returns an array of arrays sorted alphabetically by key' do
        expect(subject.sorted_values).to be_an(Array)
        expect(
          subject.sorted_values.map {|pair| pair.first}
        ).to eq(
          subject.sorted_values.map {|pair| pair.first}.sort
        )
      end
    end

    describe '#environment' do
      it 'returns the environment of node "agent"' do
        expect(subject.environment).to eq("production")
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
