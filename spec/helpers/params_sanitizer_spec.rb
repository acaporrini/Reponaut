require 'spec_helper'

RSpec.describe 'Reponaut::ParamsSanitizer' do
  let(:test_class) { Class.new { extend Reponaut::ParamsSanitizer } }

  describe '.sanitize!' do
    context 'when term param is present' do
      it 'trims the white spaces' do
        params = { term: ' test ' }
        expect(test_class.sanitize!(params)).to eq(term: 'test')
      end

      it 'caps the term string' do
        params = { term: 'A search term with more than 20 characters' }
        expect(test_class.sanitize!(params)).to eq(term: 'A search term with mo')
      end

      it 'escapes html elements' do
        params = { term: '<p>Not cool</p>' }
        expect(test_class.sanitize!(params)).to eq(term: '&lt;p&gt;Not cool&lt;')
      end
    end

    context 'when term param is not present' do
      it 'returns the params unmodified' do
        params = { another_param: ' test ' }
        expect(test_class.sanitize!(params)).to eq(another_param: ' test ')
      end
    end
  end
end
