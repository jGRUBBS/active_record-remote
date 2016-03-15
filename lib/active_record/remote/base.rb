require 'active_record/remote/helpers/association_helper'
require 'active_record/remote/helpers/request_helper'
require 'active_record/remote/helpers/serialization_helper'
require 'active_record/remote/helpers/xml_helper'
require 'active_record/remote/helpers/soap_helper'

module ActiveRecord
  module Remote
    class Base

      class_attribute :action_path, :api_type, :operation_path

      include Virtus.model
      include ActiveModel::Validations
      extend  ActiveRecord::Remote::Helpers::AssociationHelper
      extend  ActiveRecord::Remote::Helpers::RequestHelper
      include ActiveRecord::Remote::Helpers::SerializationHelper
      include ActiveRecord::Remote::Helpers::XMLHelper
      include ActiveRecord::Remote::Helpers::SOAPHelper

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
        base_module  = self.class.to_s.split('::').first.constantize
        client       = base_module.const_get("Client").new(self.class.action_path)
        request_body = send("as_#{api_type}")
        client.request(request_body)
      end

    end
  end
end
