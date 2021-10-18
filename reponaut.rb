require 'dotenv/load'
require 'sinatra/base'
require 'pagy'
require 'pagy/extras/uikit'
require 'pagy/extras/array'

require_relative 'reponaut/services/repos_searcher'
require_relative 'reponaut/lib/github_client'
require_relative 'reponaut/helpers/params_sanitizer'

module Reponaut
  # The Reponaut Server
  class Server < Sinatra::Base
    set :root, File.dirname(__FILE__)
    set(:views, proc { File.join(root, 'reponaut/views') })
    set :port, 3000
    set :raise_errors, false
    set show_exceptions: false unless ENV['DEBUG'] == true

    enable :logging

    include Pagy::Backend

    helpers do
      include Pagy::Frontend
      include Reponaut::ParamsSanitizer
    end

    Octokit.configure do |c|
      c.connection_options = {
        request: {
          open_timeout: 5,
          timeout: 5
        }
      }
    end

    before '/repos/search' do
      sanitize! params
    end

    get '/repos/search' do
      if (@term = params[:term])
        result = Reponaut::Services::ReposSearcher.call(
          term: @term,
          page: params[:page],
          search_in: params[:search_in]
        )

        if result.success?
          result_values = result.value!
          @repos = result_values[:repos]
          @search_in = params[:search_in]
          @alert = 'No repos found, try again with another search' if @repos && @repos.empty?
          @pagy = Pagy.new(count: result_values[:total_count], page: params[:page] || 1,
                           items: ENV['RESULTS_PER_PAGE'] || 20)
        else
          logger.error result.failure
          @alert = 'There was a problem with your search, please try again'
        end
      end

      @repos ||= []

      erb 'repos/search'.to_sym
    end

    not_found do
      status 404
      erb :not_found
    end

    error do
      logger.error env['sinatra.error'].message

      status 500
      erb :error
    end
  end
end
