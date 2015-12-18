module ActiveRecord::Remote
  module Helpers
    module SerializationHelper

      def to_xml
        serializable_hash.to_xml(
          root: "ITEM_FILTER",
          dasherize: false,
          skip_types: true
        )
      end

      def serializable_hash
        Hash.new.tap do |attribute_hash|
          attribute_set.each do |attribute|
            serialize_attribute(attribute_hash, attribute)
          end
        end
      end

      def serialize_attribute(attribute_hash, attribute)
        return if attributes[attribute.name].nil?
        name = _attribute_name(attribute)
        attribute_hash[name] = _serialize(attributes[attribute.name])
      end

      def _attribute_name(attribute)
        if attribute.name.to_s == "details"
          attribute.name
        else
          attribute.name
        end.upcase
      end

      def _serialize(serialized)
        if serialized.respond_to?(:serializable_hash)
          serialized.serializable_hash
        else
          case serialized
          when Array
            serialized.map { |attr| _serialize(attr) }
          when BigDecimal
            serialized.to_s("F")
          when Hash
            Hash[serialized.map{ |k, v| [k.upcase, v] }]
          else
            serialized
          end
        end
      end

    end
  end
end
