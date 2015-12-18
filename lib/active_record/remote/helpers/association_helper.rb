module ActiveRecord::Remote
  module Helpers
    module AssociationHelper

      def has_many(association, options = {})
        association_name = parse_association_name(association, options)
        set_inflection(association, options[:collection])
        self.attribute association, Array[association_klass(association_name)]
      end

      def parse_association_name(association, options = {})
        if options[:collection].present?
          options[:collection]
        else
          association
        end
      end

      def set_inflection(association, collection)
        return if collection.nil?
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
        ActiveSupport::Inflector.inflections do |inflect|
          inflect.singular association.to_s.upcase, collection.to_s.upcase
        end
      end

      def association_klass(name)
        singular = name.to_s.singularize
        ActiveRecord::Remote::Record.const_get(singular.classify)
      end

    end
  end
end
