module ActiveRecord::Remote
  module Helpers
    module AssociationHelper

      def has_many(association, options = {})
        association_name = parse_association_name(association, options)
        set_inflection(association, options)
        self.attribute association, Array[association_klass(association_name)], options
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
        # since RLM has an irregular API we have to adjust the inflections
        # so we can have children collections that do not match the parents
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
