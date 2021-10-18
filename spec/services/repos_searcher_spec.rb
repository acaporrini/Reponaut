require 'spec_helper'

RSpec.describe Reponaut::Services::ReposSearcher do
  describe '.call' do
    let(:repos_client_result) do
      OpenStruct.new(
        success?: true
      )
    end

    context 'when repos client is specified' do
      let(:repos_client) { instance_double('GithubClient') }

      before do
        allow(repos_client).to receive(:search_repos).and_return(repos_client_result)
      end

      it 'returns success' do
        expect(described_class.call(term: 'Repo', search_in: 'name', page: 1, repos_client: repos_client)).to be_success
      end
    end

    context 'when no repos client is specified' do
      before do
        allow(Reponaut::GithubClient).to receive(:search_repos).and_return(repos_client_result)
      end

      it 'returns success' do
        expect(described_class.call(term: 'Repo', search_in: 'name', page: 1)).to be_success
      end
    end
  end
end
