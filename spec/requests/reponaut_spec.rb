require 'spec_helper'

RSpec.describe 'App' do
  describe 'not_found' do
    before do
      get '/does_not_exist'
    end

    it 'returns 404 code' do
      expect(last_response.status).to eq(404)
    end

    it 'renders not_found template' do
      expect(last_response.body).to include('This page does not exist')
    end
  end

  describe 'error' do
    before do
      allow(Reponaut::Services::ReposSearcher)
        .to receive(:call)
        .and_raise(StandardError)

      get '/repos/search?term=test'
    end

    it 'returns 500 code' do
      expect(last_response.status).to eq(500)
    end

    it 'renders error template' do
      expect(last_response.body).to include('Ooops, something went wrong...')
    end
  end

  describe "describe '#repos/search" do
    context 'when no search term is passed' do
      before do
        expect(Reponaut::Services::ReposSearcher)
          .not_to receive(:call)

        get '/repos/search'
      end

      it 'responds with 200' do
        expect(last_response.status).to eq(200)
      end

      it 'renders search template' do
        expect(last_response.body).to include('Type a repo name and click search!')
      end
    end

    context 'when search term is passed' do
      let(:repo_item) do
        OpenStruct.new(
          name: 'MY_REPO',
          url: 'URL',
          description: 'DESCRIPTION'
        )
      end

      let(:service_response_success) do
        OpenStruct.new(
          success?: true,
          value!: {
            total_count: 1,
            repos: [repo_item]
          }
        )
      end

      before do
        allow(Reponaut::Services::ReposSearcher)
          .to receive(:call)
          .with(term: 'TEST', search_in: 'name', page: nil)
          .and_return(service_response_success)

        get '/repos/search?term=TEST&search_in=name'
      end

      it 'returns 200' do
        expect(last_response.status).to eq(200)
      end

      it 'renders search template' do
        expect(last_response.body).to include('MY_REPO')
      end
    end

    context 'when search term is passed and the search fails' do
      let(:service_response_failure) do
        OpenStruct.new(
          success?: false,
          failure: 'ERROR!'
        )
      end

      before do
        allow(Reponaut::Services::ReposSearcher)
          .to receive(:call)
          .with(term: 'TEST', search_in: 'name', page: nil)
          .and_return(service_response_failure)
        get '/repos/search?term=TEST&search_in=name'
      end

      it 'returns failure message on error' do
        expect(last_response.body)
          .to include('There was a problem with your search, please try again')
      end
    end

    context 'when search term and page params are passed' do
      let(:repo_item) do
        OpenStruct.new(
          name: 'MY_REPO',
          url: 'URL',
          description: 'DESCRIPTION'
        )
      end

      let(:service_response_success) do
        OpenStruct.new(
          success?: true,
          value!: {
            total_count: 100,
            repos: [repo_item]
          }
        )
      end

      before do
        allow(Reponaut::Services::ReposSearcher)
          .to receive(:call)
          .with(term: 'TEST', search_in: 'name', page: '2')
          .and_return(service_response_success)

        get '/repos/search?term=TEST&search_in=name&page=2'
      end

      it 'returns 200' do
        expect(last_response.status).to eq(200)
      end

      it 'renders search template' do
        expect(last_response.body).to include('MY_REPO')
      end
    end
  end
end
