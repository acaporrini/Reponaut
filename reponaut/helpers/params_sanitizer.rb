module Reponaut
  # A helper for parsing and cleaning search params before using them in repos search
  module ParamsSanitizer
    MAX_SEARCH_STRING_LENGTH = ENV['MAX_SEARCH_STRING_LENGTH'].to_i || 50
    # Sanitize the params hash, right now it only affect the `term` param but
    # can be extended to other params in the future.
    def sanitize!(params)
      params.each_key do |key|
        params[key] = sanitize_search_term(params[key]) if key == :term
      end
    end

    # This method transform the `term` parameter before using it to search for repos.
    # It ensures that the search string is not too long or contains unnecessary white spaces.
    # Html code is also escaped to avoid unwanted behaviours when the param is returned to the view
    # to autofil the form.
    def sanitize_search_term(term)
      term = Rack::Utils.escape_html(term)
      term = term.strip
      term = term[0..MAX_SEARCH_STRING_LENGTH] unless term.length <= MAX_SEARCH_STRING_LENGTH.to_i
      term
    end
  end
end
