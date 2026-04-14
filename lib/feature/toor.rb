
require_relative "_namespace"

module Feature
  module Toor
    # @param [Class] owner
    def self.load(owner)
      return if owner < InstanceMethods

      owner.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # Пытаемся привести +str+ к {Ingteger},
      # если не получилось -- передаём управление блоку.
      # @param [String] str
      # @return [mixed]
      # @raise [ArgumentError] Если блок не задан.
      def to_int_or(str, &block)
        raise ArgumentError, "Code block must be given" unless block

        begin
          Integer(str)
        rescue ArgumentError, TypeError
          yield
        end
      end
    end
  end
end
