module ActiveRecord::Remote
  module Helpers
    module XmlSerializationHelper

      module ClassMethods

        def rename_key(key, options = {})
          # add :upcase option to ActiveSupport::XmlMini#rename_key
          key = super.upcase if options[:upcase]
          key
        end

        def to_tag(key, value, options)
          # add :omit_nils option to ActiveSupport::XmlMini#to_tag
          return if options[:omit_nils] && value.nil? 
          super
        end

      end

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end  
      end  

    end
  end
end

ActiveSupport::XmlMini.send(:prepend, ActiveRecord::Remote::Helpers::XmlSerializationHelper)

# Not sure if some of this will be needed
#
# module ActiveRecord::Remote
#   module Helpers
#     module SerializationHelper

#       def serializable_hash
#         Hash.new.tap do |attribute_hash|
#           attribute_set.each do |attribute|
#             serialize_attribute(attribute_hash, attribute)
#           end
#         end
#       end

#       def serialize_attribute(attribute_hash, attribute)
#         return if attributes[attribute.name].nil?
#         name = _attribute_name(attribute)
#         attribute_hash[name] = _serialize(attributes[attribute.name], attribute)
#       end

#       def _attribute_name(attribute)
#         if !!attribute.options[:as]
#           attribute.options[:as]
#         elsif !!attribute.options[:strict]
#           attribute.name
#         else
#           attribute.name.upcase
#         end
#       end

#       def _serialize(serialized, attribute = nil)
#         if serialized.respond_to?(:serializable_hash)
#           serialized.serializable_hash
#         else
#           case serialized
#           when Array
#             serialized.map { |attr| _serialize(attr) }
#           when BigDecimal
#             serialized.to_s("F")
#           when Hash
#             Hash[
#               serialized.map do |k, v|
#                 k = attribute.options[:strict] ? k : k.upcase
#                 [k, v]
#               end
#             ]
#           else
#             serialized
#           end
#         end
#       end

#     end
#   end
# end
