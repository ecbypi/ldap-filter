require 'ldap-filter'

module LDAP
  module Filter

    describe Compound do
      let(:operator) { '&' } # AndOperator

      describe "#to_s" do
        it "builds all children filters and combines them with the operator" do
          filter = Compound.new(operator, { givenName: 'John', sn: ['Smith', 'Smithers']})
          filter.to_s.should eq '(&(givenName=John)(|(sn=Smith)(sn=Smithers)))'
        end
      end

      describe "can be built from a hash" do
        it "with key value pairs for base filters" do
          attributes = {
            givenName: 'John',
            sn: 'Smith'
          }
          filter = Compound.new(operator, attributes)
          filter.children.size.should eq 2
          filter.children.first.should be_instance_of LDAP::Filter::Base
        end

        it "with key values pairs to create nested compound filters" do
          attributes = {
            givenName: ['John', 'Mary', 'Tyler'],
            sn: 'Smith'
          }
          filter = Compound.new(operator, attributes)
          filter.children.size.should eq 2
          filter.children.first.should be_a LDAP::Filter::Compound
          filter.children.first.children.size.should eq 3
        end

        it "so long as more than one key is supplied" do
          expect { Compound.new('|', { givenName: 'John' }) }.to raise_error ArgumentError
        end

        it "with options for the base filter" do
          attributes = {
            givenName: { value: 'Jo', wildcard: :right },
            cn: { value: 'John Smith', wildcard: :inside }
          }

          filter = Compound.new(operator, attributes)
          filter.to_s.should eq '(&(givenName=Jo*)(cn=John*Smith))'
        end
      end

      describe "can be built from an array of string values" do
        it "can be built using a key and an array of values" do
          filter = Compound.new(operator, :givenName, 'Mary', 'John', 'Tyler')
          filter.operator.should eq '|'
          filter.children.size.should eq 3
        end

        it "can figure out if an array is passed in instead of a splat" do
          values = ['Mary', 'John', 'Tyler']
          filter = Compound.new(operator, :givenName, values)
          filter.children.size.should eq 3
        end

        it "so long as there is more than one value provided" do
          expect { Compound.new('|', :givenName, 'Mary') }.to raise_error ArgumentError
        end
      end

      describe "when built from other filter objects" do
        let(:given_name) { Base.new(:givenName, 'John') }
        let(:surname) { Base.new(:sn, 'Smith') }

        it "is done using an array of filter objects" do
          filter = Compound.new(operator, [given_name, surname])
          filter.children.size.should eq 2
          filter.children.first.should eq given_name
          filter.children.last.should eq surname
        end

        it "takes out non-filter objects when built with an array of filters" do
          filter = Compound.new(operator, [given_name, surname, 'invalid'])
          filter.children.size.should eq 2
        end
      end

      describe "compound methods" do
        let(:compound) { Compound.new '|', { givenName: 'John', sn: 'Smith' } }
        let(:base) { Base.new :mail, 'smith@email.org' }

        describe "#<<" do
          it "adds a filter to it's children" do
            expect { compound << base }.to change { compound.children.size }.by 1
          end

          it "only accepts filter objects" do
            expect { compound << 'smith@email.org' }.to raise_error ArgumentError
          end
        end

        describe "#|" do
          it "creates a new OrFilter" do
            new_filter = compound | base
            new_filter.children.should include(compound)
            new_filter.children.should include(base)
            new_filter.operator.should eq '|'
          end
        end

        describe "#&" do
          it "creates a new AndFilter" do
            new_filter = compound & base
            new_filter.children.should include(compound)
            new_filter.children.should include(base)
            new_filter.operator.should eq '&'
          end
        end
      end
    end
  end
end
