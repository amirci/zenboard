require 'spec_helper'

describe Week do
  
  before(:each) do
    @seven_days = 7 * 24 * 60 * 60
    @six_days = 6 * 24 * 60 * 60
    @last_monday = Chronic.parse('last monday 00:00')
  end
  
  it "Should return current week" do
    w = Week.current
    
    w.start.should == @last_monday
    w.finish.should == w.start + @six_days
  end
  
  it "Should return the previous week" do
    w = Week.current.previous
    
    w.start.should == @last_monday - @seven_days
  end
  
  # Checks the previous weeks are returned
  it "Should return the previous weeks" do
    previous = Week.previous(2)
    
    previous[0].should == Week.current
    previous[1].should == Week.current.previous
  end
  
end
