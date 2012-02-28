module LDAP
  module Filter
    class OrFilter < Compound

      def initialize *args
        super '|', *args
      end
    end
  end
end
