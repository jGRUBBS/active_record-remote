module ActiveRecord::Remote
  module Helpers
    module XMLHelper

      def as_xml
        serializable_hash.to_xml(xml_options)
      end

      def xml_options
        {
          root: "ITEM_FILTER",
          dasherize: false,
          skip_types: true
        }
      end

    end
  end
end
