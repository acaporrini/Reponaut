require 'octokit'
require 'dry/monads'

module Reponaut
  # A wrapper aroung the Octokit gem responsible for searching repos by a search term and
  # format the results.
  module GithubClient
    extend Dry::Monads[:result]

    module_function

    RESULTS_PER_PAGE = ENV['RESULTS_PER_PAGE'] || 20

    def client
      @client ||= Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'], per_page: RESULTS_PER_PAGE)
    end

    # The search term is used in a query to Github in order to fetch the matching repos.
    # The native Octokit pagination is also used and the total number of results is returned along with
    # the result payload to the controller to allow Pagy to build the pagination navigation.
    # The total count is capped to 1000 because that's the maximum allowed results from Github API.
    # Requesting a page number * num of items higher than that would raise an error.
    def search_repos(term:, search_in: 'name', page: 1)
      query = "#{term} in:#{search_in}"
      response = client.search_repositories(query, order: 'asc', page: page)

      repos = format_repos_response(response)
      total_count = response[:total_count] > 1000 ? 1000 : response[:total_count]

      Success(repos: repos, total_count: total_count)
    rescue Octokit::Error => e
      Failure(e.message)
    end

    def format_repos_response(response)
      response[:items].map do |i|
        OpenStruct.new(
          name: i[:name],
          url: i[:html_url],
          description: i[:description]
        )
      end
    end
  end
end
