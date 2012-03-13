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

      describe "compound methods" do
        let(:other) { Base.new(:sn, 'Smith') }

        describe "#<<" do
          it "creates an OrFilter object under the same key" do
            compound = filter << 'Smith'
            compound.should be_a OrFilter
            compound.to_s.should eq '(|(givenName=John)(givenName=Smith))'
          end
        end

        describe "#|" do
          it "builds an OrFilter of itself and the argument filter" do
            compound = filter | other
            compound.should be_a OrFilter
            compound.to_s.should eq '(|(givenName=John)(sn=Smith))'
          end
        end

        describe "#&" do
          it "builds an AndFilter of itself and the argument filter" do
            compound = filter & other
            compound.should be_a AndFilter
            compound.to_s.should eq '(&(givenName=John)(sn=Smith))'
          end
        end
      end

      describe "uses options to place wildcards" do
        it "after the value" do
          filter = Base.new :sn, 'Smith', wildcard: :right
          filter.to_s.should eq '(sn=Smith*)'
        end

        it "before the value" do
          filter = Base.new :sn, 'Smith', wildcard: :left
          filter.to_s.should eq '(sn=*Smith)'
        end

        it "inbetween pieces of the string" do
          filter = Base.new :cn, 'John Smith', wildcard: :inside
          filter.to_s.should eq '(cn=John*Smith)'
        end

        it "around the value using :left and :right options" do
          filter = Base.new :sn, 'Smith', wildcard: [:left, :right]
        end
      end
    end
  end
end
