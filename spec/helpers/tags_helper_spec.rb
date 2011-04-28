require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TagsHelper. For example:
#
# describe TagsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe TagsHelper do
  
  it "should return labels for content tag" do
    labels('a', 0, 'total', "(i.e) 1").should == '<p><label for="a">A</label>: 0</p><p><label for="total">Total</label>: (i.e) 1</p>'
  end
  
end
