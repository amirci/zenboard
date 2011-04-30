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
    expected = '<p><label for="a">A</label>: 0</p><p><label for="total">Total</label>: (i.e) 1</p>'
    column_contents('a', 0, 'total', "(i.e) 1").should == expected
  end

  it "should generate a column with the values" do
    values = ['a', 0, 'total', "(i.e.) 2"]
    content = column_contents(*values)
    column_metrics(1, *values).should == %Q{<div id="c1">#{content}</div>}
  end
  
  it "should return metrics for a collection that has all stories completed" do
    completed = [double("Story1"), double("Story2")]
    
    stub!(:stories).with(completed).and_return('tot')
    stub!(:efficiency).with(completed).and_return('eff')
    stub!(:started_date).with(completed).and_return('sd')
    stub!(:completed_date).with(completed).and_return('cd')
    stub!(:duration).with(completed).and_return('dur')
    stub!(:point_duration).with(completed).and_return('pd')

    expected = column_metrics(1, 'total', 'tot', 'eff.', 'eff (avg.)')     
    expected << column_metrics(2, 'started on', 'sd', 'finished on', 'cd')
    expected << column_metrics(3, 'duration', 'dur', '1 point', 'pd (avg.)')
    
    metrics_header(completed, [], nil).should == expected
  end
  
  it "should return metrics for collection that has some not completed stories" do
    not_completed = [double("Story1"), double("Story2")]
    completed = [double("story3")]
    project = double("Project")
    all = completed + not_completed
    
    stub!(:stories).with(all).and_return('tot')
    stub!(:stories).with(completed).and_return('com (x points)')
    stub!(:stories).with(not_completed).and_return('nc (x points)')

    stub!(:efficiency).with(completed).and_return('eff')
    stub!(:started_date).with(all).and_return('sd')
    stub!(:velocity).with(completed).and_return('vel')
    stub!(:velocity).with(project).and_return('proj. vel')
    stub!(:duration).with(completed).and_return('dur')
    stub!(:point_duration).with(completed).and_return('pd')
    stub!(:time_left).with(not_completed, project).and_return('infinite')
    stub!(:eta).with(not_completed, project).and_return('March 2014')

    expected = column_metrics(1, 'total', 'tot', 'velocity', 'vel')     
    expected << column_metrics(2, 'completed', 'com (x points)', 'left to do', 'nc (x points)')
    expected << column_metrics(3, 'eff.', 'eff', '1 point', 'pd (avg.)')
    expected << column_metrics(4, 'time to finish', 'infinite', 'projected date', 'March 2014')
    expected << column_metrics(5, 'proj. vel.', 'proj. vel')
    
    metrics_header(completed, not_completed, project).should == expected
  end
  
end
