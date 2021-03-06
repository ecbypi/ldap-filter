require 'ldap-filter'

module LDAP
  module Filter
    describe AndFilter do

      it "subclases LDAP::Filter::Compound, defaulting the operator to :&" do
        filter = AndFilter.new(givenName: 'John', sn: 'Smith')
        filter.operator.to_s.should eq '&'
      end
    end
  end
end
