require 'ldap-filter'

module LDAP
  module Filter

    describe Base do
      let(:filter) { Base.new(:givenName, 'John') }

      describe "#to_s" do
        it "puts together the pieces and returns usable filter" do
          filter.to_s.should eq '(givenName=John)'
        end
      end

      describe "#!" do
        it "inverts the filter" do
          !filter
          filter.to_s.should eq '(!givenName=John)'
        end
      end

    end
  end
end
