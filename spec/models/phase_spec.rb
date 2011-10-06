require 'spec_helper'

describe Phase do
  
  context '.initialize' do
    subject { Phase.new('Archive') }
    
    its(:name) { should == 'Archive' }
  end
  
end
