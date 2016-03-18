module ActiveRecord::Remote
  class Interface
    class Configuration

      def initialize
        @@options ||= {}
      end


      def method_missing(name, *args, &blk)
        if name.to_s =~ /=$/
          @@options[$`.to_sym] = args.first
        elsif @@options.key?(name)
          @@options[name]
        else
          super
        end
      end

    end
  end
end