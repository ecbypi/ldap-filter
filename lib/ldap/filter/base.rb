module LDAP
  module Filter
    class Base
      attr_accessor :key, :value

      def initialize key, value, options={}
        options = {
          inverse: false
        }.merge! options

        @key = key
        @value = value.to_s
        @wildcard_placements = [options[:wildcard]].flatten
        @not = options[:inverse]
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

      def << value
        OrFilter.new @key, @value, value
      end

      def | filter
        OrFilter.new [self, filter]
      end

      def & filter
        AndFilter.new [self, filter]
      end

      private

      def condition
        [
          @key, '=',
          wildcard(:left),
          value_with_wildcards,
          wildcard(:right)
        ].join
      end

      def value_with_wildcards
        return @value unless @wildcard_placements.include? :inside
        @value.split.join('*')
      end

      def wildcard position
        '*' if @wildcard_placements.include? position
      end
    end
  end
end
