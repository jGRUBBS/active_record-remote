module ActiveRecord::Remote
  module Helpers
    module SOAPHelper

      def as_soap
        serializable_hash.to_soap(soap_options)
      end

      def soap_options
        {
          dasherize:  false,
          skip_types: true,
          omit_nils:  true
        }
      end

    end
  end
end
