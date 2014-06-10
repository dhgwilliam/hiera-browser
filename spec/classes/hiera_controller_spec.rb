require 'spec_helper'

describe HieraController do
  context 'when initialized with hiera_clean.yaml' do
    let(:hiera) { HieraController.new(
      :hiera_yaml => File.join($fixtures_path, 'hiera_clean.yaml')
    ) }

    let(:scope) { { '::hostname'   => 'agent', '::datacenter' => 'pdx', } }

    describe '#hiera' do
      it 'has a properly initialized Hiera object' do
        expect(hiera.hiera).to be_a(Hiera)
        expect(hiera.config).to be_a(Hash)
        expect(hiera.config).to include(
          :backends => ["yaml"],
          :yaml => { :datadir => "./spec/fixtures/hieradata" }
        )
      end
    end

    describe '#datadirs' do
      it 'returns an array of DataDir objects' do
        expect(hiera.datadirs).to be_an(Array)
        hiera.datadirs.each {|d|
          expect(d).to be_a(DataDir)}
      end
    end

    describe '#keys' do
      it 'returns a sorted list of all Hiera keys present in the #datadirs' do
        keys = hiera.keys
        expect(keys).to be_an(Array)
        expect(keys).to eq(["test_array", "test_bool", "test_hash", "test_string"])
      end
    end

    describe '#hierarchy' do
      it 'exposes the hierarchy' do
        h = hiera.hierarchy
        expect(h).to be_an(Array)
        expect(h).to eq(["hostname/%{::hostname}", "datacenter/%{::datacenter}", "common"])
      end
    end
    
    describe '#top_scopify' do
      it 'fully qualifies keys when they are fully qualified in `hiera.yaml`' do
        s = hiera.top_scopify(:scope => {
          'environment' => 'dev',
          'hostname'    => 'test.puppetlabs.com',
          'datacenter'  => 'pdx',
        })

        expect(s).to be_a(Hash)
        expect(s).to eq({
          'environment'  => 'dev',
          'hostname'     => 'test.puppetlabs.com',
          'datacenter'   => 'pdx',
          '::hostname'   => 'test.puppetlabs.com',
          '::datacenter' => 'pdx',
        })
      end
    end

    describe '#lookup' do
      context 'when called with no arguments' do
        it 'fails gracefully' do
          expect { hiera.lookup() }.to raise_error(ArgumentError)
        end
      end

      context 'when passed a :key, :scope and no :resolution_type' do
        let(:key) { 'test_string' }
        let(:lookup) { hiera.lookup(:key => key, :scope => scope) }

        it 'retrieves a value from hiera using priority override' do
          expect(lookup).to be_a(Hash)
          expect(lookup.values.first).to be_a(String)
          expect(lookup.values).to include('test_string value from pdx.yaml')
        end
      end

      context 'when passed a :key, :scope and :resolution_type => :hash' do
        let(:key) { 'test_hash' }
        let(:scope) { {
          '::hostname'   => 'agent',
          '::datacenter' => 'pdx',
        } }
        let(:resolution_type) { :hash }
        let(:subject) { 
          hiera.lookup(:key             => key,
                       :scope           => scope,
                       :resolution_type => resolution_type)
        }

        it 'retrieves a value from hiera using hash resolution type' do
          expect(subject).to be_a(Hash)
          expect(subject).to eq(
            'test_hash' => {
              'test_hash_key1'         => "test_hash_key1 value from pdx.yaml",
              "test_hash_key2"         => "test_hash_key2 value from pdx.yaml",
              "test_hash_key3"         => "test_hash_key3 value from pdx.yaml",
              "test_hash_merge_common" => "test_hash_merge_key from common.yaml",
              "test_hash_merge_pdx"    => "test_hash_merge_key from pdx.yaml"
            }
          )
        end
      end
    end

    describe '#get_all' do
      context 'when called with a valid scope and no additive keys' do
        let(:subject) { hiera.get_all(:scope => scope) }

        it 'returns a hash of keys and values' do
          expect(subject).to be_a(Hash)
          expect(subject).to eq( {
            "test_array"  =>  {"test_array"=>["array value 1 from pdx.yaml", "array value 2 from pdx.yaml", "array value 3 from pdx.yaml"]},
            "test_bool"   =>  {"test_bool"=>false},
            "test_hash"   =>  {"test_hash"=>{"test_hash_key1"=>"test_hash_key1 value from pdx.yaml", "test_hash_key2"=>"test_hash_key2 value from pdx.yaml", "test_hash_key3"=>"test_hash_key3 value from pdx.yaml", "test_hash_merge_pdx"=>"test_hash_merge_key from pdx.yaml"}},
            "test_string" =>  {"test_string"=>"test_string value from pdx.yaml"}}
          )
        end
      end

      context 'when called with a valid scope and one additive key' do
        let(:additive_keys) { [ 'test_hash' ] }
        let(:subject) { hiera.get_all(:scope => scope, :additive_keys => additive_keys) }

        it 'returns a hash of keys and values' do
          expect(subject).to be_a(Hash)
          expect(subject).to eq({
            "test_array"  =>  {"test_array"=>["array value 1 from pdx.yaml", "array value 2 from pdx.yaml", "array value 3 from pdx.yaml"]},
            "test_bool"   =>  {"test_bool"=>false},
            "test_string" =>  {"test_string"=>"test_string value from pdx.yaml"},
            "test_hash"   =>  {"test_hash"=>{"test_hash_key1"=>"test_hash_key1 value from pdx.yaml", "test_hash_key2"=>"test_hash_key2 value from pdx.yaml", "test_hash_key3"=>"test_hash_key3 value from pdx.yaml", "test_hash_merge_common"=>"test_hash_merge_key from common.yaml", "test_hash_merge_pdx"=>"test_hash_merge_key from pdx.yaml"}}
          })
        end
      end
    end

    describe '#lookup_additive' do
      context 'when called with a valid :key and :scope on a Hash value' do
        let(:subject) { hiera.lookup_additive(:key => 'test_hash', :scope => scope) }

        it 'determines the correct resolution type and returns all values for :key' do
          expect(subject).to be_a(Hash)
          expect(subject).to eq(
            "test_hash"=>{"test_hash_key1"=>"test_hash_key1 value from pdx.yaml", "test_hash_key2"=>"test_hash_key2 value from pdx.yaml", "test_hash_key3"=>"test_hash_key3 value from pdx.yaml", "test_hash_merge_common"=>"test_hash_merge_key from common.yaml", "test_hash_merge_pdx"=>"test_hash_merge_key from pdx.yaml"}
          )
        end
      end

      context 'when called with a valid :key and :scope on a boolean' do
        let(:key) { 'test_bool' }
        let(:subject) { hiera.lookup_additive(:key => key, :scope => scope) }

        it 'determines the correct resolution type and returns a single value for :key' do
          expect(subject).to be_a(Hash)
          expect(subject).to eq(hiera.lookup(:key => key, :scope => scope))
        end
      end

      context 'when called with a valid :key and :scope on an array' do
        let(:key) { 'test_array' }
        let(:subject) { hiera.lookup_additive(:key => key, :scope => scope) }

        it 'determines the correct resolution type and returns a single value for :key' do
          expect(subject).to be_a(Hash)
          expect(subject).to_not eq(hiera.lookup(:key => key, :scope => scope))
          expect(subject).to eq(
            {"test_array"=>["array value 1 from pdx.yaml", "array value 2 from pdx.yaml", "array value 3 from pdx.yaml", "array value 1 from common.yaml", "array value 2 from common.yaml", "array value 3 from common.yaml"]}
          )
        end
      end
    end
  end
end
