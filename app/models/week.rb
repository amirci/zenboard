class Week
  attr_reader :start, :finish

  # Starts a week from a date
  def initialize(start)
    @seven_days = 7 * 24 * 60 * 60
    @six_days = 6 * 24 * 60 * 60
      @start = Time.parse(start.to_s)
    @start = Time.parse(@start.strftime('%Y-%m-%d'))
    @finish = @start + @six_days
  end
  
  # Checks a date is included in the week
  def include?(date)
    date = Time.parse(date.to_s)
    date >= start && date <= finish
  end
  
  # Returns the previous week
  def previous
    Week.new(start - @seven_days)
  end
  
  # Current week
  def self.current
    modulo = Date.today.wday.modulo(7)
    modulo = 7 if modulo == 0
    last_monday = Time.parse((Date.today - modulo + 1).to_s)
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
    !other.nil? && @start == other.start && @finish == other.finish
  end

  alias eql? ==
end