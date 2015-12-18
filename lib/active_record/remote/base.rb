require 'active_record/remote/helpers/association_helper'
require 'active_record/remote/helpers/validation_helper'
require 'active_record/remote/helpers/request_helper'
require 'active_record/remote/helpers/authentication_helper'
require 'active_record/remote/helpers/serialization_helper'

module ActiveRecord
  module Remote
    class Base

      include Virtus.model
      extend  ActiveRecord::Helpers::AssociationHelper
      extend  ActiveRecord::Helpers::ValidationHelper
      extend  ActiveRecord::Helpers::RequestHelper
      extend  ActiveRecord::Helpers::AuthenticationHelper
      include ActiveRecord::Helpers::SerializationHelper

      def save
      end

    end
  end
end
