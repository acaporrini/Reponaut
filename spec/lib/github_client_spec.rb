require 'spec_helper'

RSpec.describe Reponaut::GithubClient do
  describe 'search_repos', :vcr do
    context 'when the request to GitHub is successful' do
      it 'returns success' do
        result = described_class.search_repos(term: 'vcr', search_in: 'name')

        expect(result).to be_success
      end

      it 'returns the count of repos' do
        result = described_class.search_repos(term: 'vcr', search_in: 'name')

        expect(result.value![:total_count]).to eq(925)
      end

      it 'without search_in attribute it searches in names' do
        result = described_class.search_repos(term: 'vcr')

        expect(result.value![:total_count]).to eq(925)
      end

      it 'with search_in description attribute it searches in description' do
        result = described_class.search_repos(term: 'vcr', search_in: 'description')

        expect(result.value![:total_count]).to eq(259)
      end

      it 'caps the count of repos to 1000' do
        result = described_class.search_repos(term: 'test', search_in: 'name')

        expect(result.value![:total_count]).to eq(1000)
      end

      it 'returns repos formatted' do
        result = described_class.search_repos(term: 'test', search_in: 'name')

        expect(result.value![:repos].first).to have_attributes(
          name: 'testing-samples',
          url: 'https://github.com/android/testing-samples',
          description: 'A collection of samples demonstrating different frameworks and techniques for automated testing'
        )
      end

      it 'paginates the results' do
        result = described_class.search_repos(term: 'test', page: 2, search_in: 'name')

        expect(result.value![:repos].first).to have_attributes(
          name: 'Testnet3-Challenges',
          url: 'https://github.com/Concordium/Testnet3-Challenges',
          description: 'This repo is dedicated to Concordium Incentivized Testnet3. '
        )
      end
    end

    context 'when the request raises an error' do
      before do
        allow(described_class.client).to receive(:search_repositories).and_raise(Octokit::Error)
      end

      it 'returns failure' do
        result = described_class.search_repos(term: 'test', page: 2, search_in: 'name')

        expect(result).not_to be_success
      end

      it 'returns failure message' do
        result = described_class.search_repos(term: 'test', page: 2, search_in: 'name')

        expect(result.failure).to eq 'Octokit::Error'
      end
    end
  end
end
