class Week
  attr_reader :start, :finish

  # Starts a week from a date
  def initialize(start)
    @start = Time.parse(start.to_s)
    @finish = @start + 6 * 24 * 60 * 60
  end
  
  # Checks a date is included in the week
  def include?(date)
    date = Time.parse(date.to_s)
    date >= start && date <= finish
  end
  
  # Returns the previous week
  def previous
    Week.new(start - 7 * 24 * 60 * 60)
  end
  
  # Current week
  def self.current
    last_monday = Time.parse((Date.today - Date.today.cwday.modulo(7)[1]).to_s)
    Week.new(last_monday)
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