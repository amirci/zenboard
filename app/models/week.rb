class Week
  attr_reader :start, :finish

  # Starts a week from a date
  def initialize(start)
    @start = start
    @finish = start + 6 * 24 * 60 * 60
  end
  
  # Checks a date is included in the week
  def include?(date)
    date >= start && date <= finish
  end
  
  # Returns the previous week
  def previous
    Week.new(start - 7 * 24 * 60 * 60)
  end
  
  # Current week
  def self.current
    Week.new(Chronic.parse('last monday'))
  end
  
  # Gets the previous weeks including the current
  def self.previous(amount)
    current = Week.current
    weeks = [current]
    amount.times do |i|
      current = current.previous
      weeks << current
    end
    weeks
  end
  
  def ==(other)
    @start == other.start && @finish == other.finish
  end

  alias eql? ==
end