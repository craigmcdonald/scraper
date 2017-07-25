require 'spec_helper'

describe Grattoir::Data::Parser do
  let(:json_invalid) {described_class.parse('string')}
  let(:json_valid) { described_class.parse("{\"a\": \"string\"}")}

  it 'should raise an error if passed an invalid JSON string' do
    expect { json_invalid }.to raise_error(JSON::ParserError)
  end

  it 'should not raise an error if passed a valid JSON string' do
    expect { json_valid }.to_not raise_error
  end

  it 'should return {a: "string"}' do
    expect(json_valid).to eq({a: "string"})
  end

  describe 'with collection fixture' do
    include_context 'raw collection data'
    let(:json) { described_class.parse(file) }

    it 'should include 66840953 in the array of hashes' do
      ids = json[:properties].map { |p| p[:id] }
      expect(ids).to be_kind_of(Array)
      expect(ids).to include(66840953)
    end
  end
end
