require 'spec_helper'

describe HieraController do
  context 'when initialized with hiera_clean.yaml' do
    let(:hiera) { HieraController.new(
      :hiera_yaml => File.join($fixtures_path, 'hiera_clean.yaml')
    ) }

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
        let(:scope) { {
          '::hostname' => 'agent',
          '::datacenter' => 'pdx',
        } }
        let(:h) { hiera.lookup(:key => 'test_string', :scope => scope) }

        it 'retrieves a value from hiera using priority override' do
          expect(h).to be_a(Hash)
          expect(h.values.first).to be_a(String)
          expect(h.values).to include('test_string value from pdx.yaml')
        end
      end
    end

  end
end
