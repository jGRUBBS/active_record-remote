module ActiveRecord
  module Remote
    class Interface

      autoload :Configuration, "active_record/remote/interface/configuration"

      def config
        @config ||= Interface::Configuration.new
      end

      def config=(configuration)
        @config = configuration
      end

    end
  end
end