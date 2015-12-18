module ActiveRecord::Remote
  module Helpers
    module ValidationHelper

      def validates_presence(*args)
        define_method(:requires_validations) do
          args
        end
      end

      def self.extended(descendant)
        descendant.send(:include, ClassMethods)
      end

      module ClassMethods

        def valid?
          invalid_fields.blank?
        end

        def invalid_fields
          requires_validations.select do |validation|
            send(validation).blank?
          end
        end

        def errors
          invalid_fields.map { |field| { field => [presence_message] } }
        end

        def full_error_messages
          "#{invalid_fields.join(", ")} #{presence_message}"
        end

        def presence_message
          "can't be blank"
        end

      end

    end
  end
end
