require 'spec_helper'

describe Grattoir::Data::Model do

  describe 'accessing @data' do

    let(:json_obj) { described_class.new({a: "string"}) }

    it 'should return a value for :a' do
      expect(json_obj[:a]).to eq('string')
    end

    it 'should return true for a valid key' do
      expect(json_obj.has_key? :a).to be
    end

    it 'should return false for an invalid key' do
      expect(json_obj.has_key? :b).to_not be
    end
  end

  describe 'accesing nested data' do
    let(:json_obj) { described_class.new({a:{b:"c"},d:{e:"f"}}) }

    it 'should return true for :b' do
      expect(json_obj.has_key? :b).to be
    end

    it 'should return true for :d' do
      expect(json_obj.has_key? :d).to be
    end

    it 'should return true for :e' do
      expect(json_obj.has_key? :d).to be
    end

    it 'should return [:a,:b,:d,:e] for #keys' do
      expect(json_obj.keys).to eq([:a,:b,:d,:e])
    end

    it 'should return "c" for a key of :b' do
      expect(json_obj[:b]).to eq('c')
    end

    it 'should return nil for a key of :p' do
      expect(json_obj[:p]).to_not be
    end
  end

  describe 'acccessing data from fixture' do
    include_context 'sample data'
    let(:json_obj) { described_class.new(file) }

    it 'should return true for postcode' do
      expect(json_obj.has_key? :postcode).to be
    end

    it 'should return true for beds' do
      expect(json_obj.has_key? :beds).to be
    end

    it 'should return true for price' do
      expect(json_obj.has_key? :price).to be
    end
  end

  describe 'accessing empty data' do
    let(:json_obj) { described_class.new({}) }

    it 'should return false for postcode' do
      expect(json_obj.has_key? :postcode).to_not be
    end
  end

  describe 'accessing a complete search response fixture' do
    include_context 'search response data'
    let(:json_obj) { described_class.new(file)}

    it 'should include a price of 795' do
      prices = json_obj[:properties].map {|a| a[:amount] }
      expect(prices).to include(795)
    end
  end

  describe 'deep merging' do

    let(:data1) { {a: {b: {c: :d}}} }
    let(:data2) { {a: {b: {e: :f}}} }
    let(:obj1) { described_class.new(data1) }
    let(:obj2) { described_class.new(data2) }
    let(:key_not_found) { Grattoir::Errors::KeyNotFound }

    describe 'deep copy' do
      it 'should return a new object' do
        expect(obj1.deep_copy.object_id).to_not eq(obj1.object_id)
      end
    end

    it 'should raise DeepMergeError::KeyNotFound for a missing key' do
      expect { obj1.deep_merge_at(:z, obj2) }.to raise_error(key_not_found)
    end

    it 'should merge the two values for :b into a Data::Collection' do
      #TODO This is actually returning an Array, but it probably should be a Data::Collection.
      result = obj1.deep_merge_at(:b, obj2)
      expect(result[:b].count).to eq(2)
    end

    describe 'merging Data::Models containing collections' do
      let(:coldata1) { {b: [{c: :d},{e: :f}]} }
      let(:coldata2) { {b: [{w: :q},{r: :t}]} }
      let(:colobj1) { described_class.new(coldata1) }
      let(:colobj2) { described_class.new(coldata2) }

      it 'should merge two Data::Collections into a single Data::Collection' do
        result = colobj1.deep_merge_at(:b, colobj2)
        expect(result[:b].count).to eq(4)
      end


      describe 'upserting at the correct place' do
        let(:data) { {a: {b: {c: {d: :e}}}, f: {g: {h: :i}}} }
        let(:obj) { described_class.new(data)}
        let(:obj2) { described_class.new(data)}

        it '#key_with_parents should return [:f,:g:,:h] for :h' do
          expect(obj.key_with_parents(:h)).to eq([:f,:g,:h])
        end

        it '#key_with_parents should return [:a,:b:,:c] for :c' do
          expect(obj.key_with_parents(:c)).to eq([:a,:b,:c])
        end

        it '#method_array should return correct array for :c' do
          expect(obj.method_array(:c))
          .to eq([["[]","a"],["[]","b"],["[]=","c"]])
        end

        it '#method_array should return correct array for :h' do
          expect(obj.method_array(:h))
        .to eq([["[]","f"],["[]","g"],["[]=","h"]])
        end

        it '#method_array should return correct array for :f' do
          expect(obj.method_array(:f))
          .to eq([["[]=","f"]])
        end
      end
    end

    describe 'trying to merge objects with keys at different levels' do
      let(:data3) { {b: {a: {l: :p}}} }
      let(:obj3) { described_class.new(data3) }
      let(:mismatched_keys) { Grattoir::Errors::MismatchedKeys }

      it 'should raise Errors::MismatchedKeys' do
        expect { obj1.deep_merge_at(:a, obj3) }.to raise_error(mismatched_keys)
      end
    end
  end
end
