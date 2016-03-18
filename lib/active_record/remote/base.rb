require 'active_record/remote/helpers/association_helper'
require 'active_record/remote/helpers/request_helper'
require 'active_record/remote/helpers/xml_helper'
require 'active_record/remote/helpers/soap_helper'
require 'active_record/remote/helpers/authentication_helper'
require 'active_record/remote/helpers/xml_serialization_helper'

module ActiveRecord
  module Remote
    class Base

      class_attribute :action_path, :operation_path, :base_element_name,
                      :api_type, :registered_associations

      include Virtus.model
      include ActiveModel::Validations
      include ActiveModel::Serialization
      extend  ActiveRecord::Remote::Helpers::AssociationHelper
      extend  ActiveRecord::Remote::Helpers::RequestHelper
      include ActiveRecord::Remote::Helpers::XMLHelper
      include ActiveRecord::Remote::Helpers::SOAPHelper

      attr_accessor :response, :raw_data, :parsed_data

      def self.api_type(type)
        self.api_type = type
      end

      def initialize(options = {})
        super(options.merge(custom_options))
      end

      def custom_options
        # overwrite in subclass to provide custom options to initalizer
      end

      def attributes
        # Virtus attributes has symbolized keys and ActiveModel
        # serialization depends on string keys
        super.deep_transform_keys(&:to_s)
      end

      def serializable_hash(options = {})
        # option[:include] is necessary for serialization
        # to work for associations
        super(options.merge(include: registered_associations))
      end

      def save
        request_body = send("as_#{api_type}")
        raw_response = client.request(request_body)
        @response    = handle_response(raw_response)
        valid?
      end

      def valid?
        if response.present?
          # all model validations may pass, but response
          # may have contained an error message
          response.success?
        else
          # use model validations
          super
        end
      end

      def base_module
        self.class.to_s.split('::').first.constantize
      end

      def handle_response(response)
        base_module.const_get("Response").new(
          operation: self.class.operation_path,
          raw_response: response,
          instance: self
        )
      end

      def client
        base_module.const_get("Client").new(self.class.action_path)
      end

    end
  end
end
