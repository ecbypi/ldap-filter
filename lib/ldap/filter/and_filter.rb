module LDAP
  module Filter
    class AndFilter < Compound

      def initialize *args
        super '&', *args
      end
    end
  end
end
