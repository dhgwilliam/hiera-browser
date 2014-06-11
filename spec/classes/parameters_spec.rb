require 'spec_helper'

describe ParameterCollection do
  let(:parameter_one) { Parameter.new(:key => 'datacenter', :value => 'pdx' ) }
  let(:parameter_two) { Parameter.new(:key => 'datacenter', :value => 'bvn' ) }

  context 'when a new parameter is appended to the collection' do
    let(:subject) { ParameterCollection.new }

    describe '#count' do
      it 'returns the number of parameters' do
        subject << parameter_one
        expect(subject.count).to eq(1)
        subject << parameter_two
        expect(subject.count).to eq(2)
      end
    end
  end

  context 'when a duplicate parameter is appended to the collection' do
    let(:subject) { ParameterCollection.new }

    it 'returns a Collection with no duplicates' do
      subject << parameter_one
      expect(subject.count).to eq(1)
      subject << parameter_two
      expect(subject.count).to eq(2)
      subject << parameter_two
      expect(subject.count).to eq(2)
    end
  end

  context 'when a Collection has multiple Parameters with the same key' do
    let(:subject) { 
      ParameterCollection.new << parameter_one << parameter_two
    }

    describe '#[:key]' do
      it 'returns an array with all values' do
        expect(subject['datacenter']).to be_an(Array)
        expect(subject['datacenter']).to eq(['pdx','bvn'])
      end
    end

    describe '#to_h' do
      it 'returns a Hash' do
        expect(subject.to_h).to be_a(Hash)
      end
    end
  end

end

describe Parameter do
  let(:unqualified_key) { 'datacenter' }
  let(:qualified_key) { '::datacenter' }
  
  context 'when initialized with no :key or :value' do
    let(:subject) { Parameter.new() }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'when initialized with a :key but no :value' do
    let(:subject) { Parameter.new(:key => unqualified_key) }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'when initialized with a :value but no :key' do
    let(:subject) { Parameter.new(:value => 'pdx') }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'when initialized with both a :value and a :key' do
    let(:subject) { Parameter.new(:key => unqualified_key, :value => 'pdx') }

    it 'has the correct :key and :value' do
      expect(subject).to respond_to(:key)
      expect(subject).to respond_to(:value)
      expect(subject.key).to eq('datacenter')
      expect(subject.value).to eq('pdx')
    end
  end

  context 'when initialized with a top-scope :key' do
    let(:subject) { Parameter.new(:key => qualified_key, :value => 'pdx') }

    it 'descopes the :key properly' do
      expect(subject.key).to eq('datacenter')
    end

    describe '#top_scope_key' do
      it 'returns a fully-qualified key' do
        expect(subject.top_scope_key).to eq('::datacenter')
      end
    end
  end
end
