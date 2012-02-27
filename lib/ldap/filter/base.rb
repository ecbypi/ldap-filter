module LDAP
  module Filter
    class Base
      attr_accessor :key, :value

      def initialize key, value, inverse=false
        @key = key
        @value = value.to_s
        @not = inverse
      end

      def to_s
        filter = '('
        filter << '!' if @not
        filter << condition
        filter << ')'
      end

      def !
        @not = !@not
        self
      end

      private

      def condition
        [@key, '=', @value].join
      end
    end
  end
end
