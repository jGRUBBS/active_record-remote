module ActiveRecord
  module Remote
    class Response

      attr_accessor :parsed_response, :options

      def initialize(options)
        @options = options
        handle_response(options[:raw_response])
      end

      def operation
        options[:operation]
      end

      def record_instance
        options[:instance]
      end

      def success?
        record_instance.errors.blank?
      end

      def handle_response(response)
        # implement in subclass
      end

      def response_message
        # implement in subclass
      end

      def valid?
        # implement in subclass
      end

    end
  end
end
