require "net/http"
require "net/https"

module ActiveRecord
  module Remote
    class Client

      cattr_accessor :content_type, :host
      attr_accessor :action

      def initialize(action)
        @action = action
      end

      def self.content_type(content_type)
        self.content_type = content_type
      end

      def self.host(host)
        self.host = host
      end

      def http
        Net::HTTP.new(host)
      end

      def formatted_action
        action
      end

      def formatted_path
        "/#{endpoint_path}/#{formatted_action}"
      end

      def endpoint_path
        # define in subclass
      end

      def request(request_body)
        request              = Net::HTTP::Post.new(formatted_path)
        request.body         = request_body
        request.content_type = content_type
        request.add_field("SOAPAction", "")
        http.request(request)
      end

    end
  end
end
