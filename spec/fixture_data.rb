require 'spec_helper'

shared_context 'sample data' do
  let(:file) { Grattoir::Data::Parser.parse(File.open("#{__dir__}/fixtures/sample.json").read) }
end

shared_context 'collection data' do
  let(:file) { Grattoir::Data::Parser.parse(File.open("#{__dir__}/fixtures/collection.json").read) }
end

shared_context 'raw collection data' do
  let(:file) { File.open("#{__dir__}/fixtures/collection.json").read }
end

shared_context 'search response data' do
  let(:file) { Grattoir::Data::Parser.parse(File.open("#{__dir__}/fixtures/search_response.json").read) }
end
