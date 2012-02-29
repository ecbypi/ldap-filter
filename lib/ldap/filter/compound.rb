module LDAP
  module Filter
    class Compound

      attr_reader :children, :operator

      def initialize operator, key_or_mappings, *values
        @children = case key_or_mappings
                    when Symbol then populate_from_values key_or_mappings, values
                    when Array then grep key_or_mappings
                    when Hash then populate_from_hash key_or_mappings
                    end
        @operator = operator unless @operator
      end

      def to_s
        filter = '('
        filter << @operator.to_s
        filter << @children.map(&:to_s).join
        filter << ')'
      end

      def << filter
        raise ArgumentError, 'invalid representation of a filter' unless valid_filter?(filter)
        @children << filter
      end

      def | filter
        OrFilter.new [self, filter]
      end

      def & filter
        AndFilter.new [self, filter]
      end

      private

      def valid_filter? filter
        filter.kind_of?(Base) ||
          filter.kind_of?(Compound)
      end

      def grep filters
        filters.select { |filter| valid_filter? filter }
      end

      def populate_from_hash mappings
        raise ArgumentError, 'compound filters require more than one key' if mappings.keys.size < 2
        mappings.map do |key, values|
          case values
          when Array then Compound.new('|', key, *values)
          else Base.new(key, values)
          end
        end
      end

      def populate_from_values key, values
        values = values.flatten
        raise ArgumentError, "need more than one value for compound filter on the same key: #{key.inspect}, #{values.inspect}" if values.size < 2
        @operator = '|' # Cannot &'d values on the same key
        values.map { |value| Base.new(key, value) }
      end
    end
  end
end
