require 'active_record/remote/helpers/association_helper'
require 'active_record/remote/helpers/request_helper'
require 'active_record/remote/helpers/serialization_helper'
require 'active_record/remote/helpers/xml_helper'
require 'active_record/remote/helpers/soap_helper'

module ActiveRecord
  module Remote
    class Base

      class_attribute :action_path, :api_type, :operation_path, :base_element_name

      include Virtus.model
      include ActiveModel::Validations
      extend  ActiveRecord::Remote::Helpers::AssociationHelper
      extend  ActiveRecord::Remote::Helpers::RequestHelper
      include ActiveRecord::Remote::Helpers::SerializationHelper
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

      def save
        @response = handle_response(request)
        valid?
      end

      def self.where(attrs)
        instance = new(attrs)
        instance.response = instance.handle_response(instance.request)
        instance.parse_records
      end

      def self.all
        where({})
      end

      def request
        request_body    = send("as_#{api_type}")
        client.api_type = api_type
        client.request(request_body)
      end

      def update_attributes(attrs)
        attrs.each { |k, v| send("#{k}=", v) }
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

      def full_module
        self.class.to_s.split('::')[0..-2].join('::').constantize
      end

      def record_class
        self.class.to_s.split('::').last
      end

      def parse_records
        data = response.data.is_a?(Array) ? response.data : [response.data]
        return [] if data.compact.empty?
        data.flat_map do |data_item|
          instance = self.class.new
          read_attributes = "#{record_class}ReadAttributes"
          if full_module.const_defined?(read_attributes)
            instance.extend(read_attributes.constantize)
          end
          attrs = data_item.transform_keys! {|k| k.downcase.to_sym }
          instance.update_attributes(attrs)
          instance
        end
      end

      def handle_response(response)
        base_module.const_get("Response").new(
          operation:    self.class.operation_path,
          raw_response: response,
          instance:     self
        )
      end

      def client
        base_module.const_get("Client").new(self.class.action_path)
      end

    end
  end
end
