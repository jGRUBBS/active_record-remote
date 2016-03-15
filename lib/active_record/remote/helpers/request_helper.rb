module ActiveRecord::Remote
  module Helpers
    module RequestHelper

      def action(kind)
        self.action_path = kind
      end

      def operation(kind)
        self.operation_path = kind
      end

    end
  end
end
