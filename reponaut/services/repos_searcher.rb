require_relative 'base'

module Reponaut
  module Services
    # Service in charge of fetching a list of repositories.
    # The Repos client is passed as parameter to allow to extend the service
    # with other clients if this will be required in the future.
    class ReposSearcher < Base
      def call(term:, search_in:, page:, repos_client: GithubClient)
        repos_client.search_repos(term: term, page: page, search_in: search_in)
      end
    end
  end
end
