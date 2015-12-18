require 'active_record/remote/helpers/association_helper'
require 'active_record/remote/helpers/validation_helper'
require 'active_record/remote/helpers/request_helper'
require 'active_record/remote/helpers/authentication_helper'
require 'active_record/remote/helpers/serialization_helper'

module ActiveRecord
  module Remote
    class Base

      include Virtus.model
      extend  ActiveRecord::Remote::Helpers::AssociationHelper
      extend  ActiveRecord::Remote::Helpers::ValidationHelper
      extend  ActiveRecord::Remote::Helpers::RequestHelper
      extend  ActiveRecord::Remote::Helpers::AuthenticationHelper
      include ActiveRecord::Remote::Helpers::SerializationHelper

      def save
      end

    end
  end
end
