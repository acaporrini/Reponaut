module Reponaut
  module Services
    # Parent class that defines common behaviour to be inherited by each service of the app
    class Base
      def self.call(**args)
        new.call(**args)
      end
    end
  end
end
