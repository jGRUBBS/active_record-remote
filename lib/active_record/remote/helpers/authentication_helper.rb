module ActiveRecord::Remote
  module Helpers
    module AuthenticationHelper

      def authentication_hash
        # FIXME: needs to pull from client
        {
          username:  "XXUSER",
          key_value: "XXKEY"        
        }
      end

      def authenticate
        self.attribute :authentication, Hash, default: authentication_hash
      end

    end
  end
end