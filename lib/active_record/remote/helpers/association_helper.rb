module ActiveRecord::Remote
  module Helpers
    module AssociationHelper

      def has_many(association, options = {})
        association_name = parse_association_name(association, options)
        set_inflection(association, options)
        register_association(association)
        attribute association, Array[association_klass(association_name)], options
      end

      private

      def register_association(association)
        self.registered_associations = [] if registered_associations.blank?
        self.registered_associations << association
      end

      def parse_association_name(association, options = {})
        if options[:collection].present?
          options[:collection]
        else
          association
        end
      end

      def set_inflection(association, options)
        return if options[:collection].nil?
        # for irregular APIs we have to adjust the inflections can have
        # children collections that do not match the parents
        # i.e.
        # <DETAILS>
        #   <LINE>
        # instead of default behavior
        # <DETAILS>
        #   <DETAIL>
        #
        # the code below dynamically adjusts active_support inflections
        # here is a basic example
        #
        # ActiveSupport::Inflector.inflections do |inflect|
        #   inflect.singular 'DETAILS', 'LINE'
        # end
        if options[:strict]
          assoc_name = association.to_s
          collection = options[:collection].to_s
        else
          assoc_name = association.to_s.upcase
          collection = options[:collection].to_s.upcase
        end
        ActiveSupport::Inflector.inflections do |inflect|
          inflect.singular assoc_name, collection
        end
      end

      def association_klass(name)
        singular = name.to_s.singularize
        parent_module = to_s.split('::')[0..-2].join('::').constantize
        parent_module.const_get(singular.classify)
      end

    end
  end
end
