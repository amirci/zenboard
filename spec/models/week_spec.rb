require 'spec_helper'

describe Week do
  
  before(:each) do
    @seven_days = 7 * 24 * 60 * 60
    @six_days = 6 * 24 * 60 * 60
    @last_monday = Chronic.parse('last monday 00:00')
  end
  
  it "Should return current week" do
    #Date.today.stub()
    w = Week.current    
    w.start.should == @last_monday
    w.finish.should == w.start + @six_days
  end
  
  it "Should calculate the week starting each day" do
    (0..6).each do |days|
      w = Week.new(@last_monday + days)      
      w.start.should == @last_monday
      w.finish.should == w.start + @six_days
    end
  end

  it "Should return the previous week" do
    w = Week.current.previous
    
    w.start.should == @last_monday - @seven_days
  end
  
  # Checks the previous weeks are returned
  it "Should return the previous weeks" do
    previous = Week.previous(4)
    
    previous[0].should == Week.current
    previous[1].should == Week.current.previous
    previous[2].should == Week.current.previous.previous
    previous[3].should == Week.current.previous.previous.previous
  end
  
end
