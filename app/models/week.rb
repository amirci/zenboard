class Week
  attr_reader :start, :finish

  SevenDays = 7 * 24 * 60 * 60
  SixDays = 6 * 24 * 60 * 60

  class << self
    # Current week
    def current(date = nil)
      date ||= Date.today
      modulo = date.wday.modulo(7)
      modulo = 7 if modulo == 0
      last_monday = Time.parse((date - modulo + 1).to_s)
      Week.new(last_monday)
    end

    # Gets the previous weeks including the current
    def previous(amount)
      amount.times.inject([Week.current]) { |weeks, i| weeks << weeks.last.previous}
    end
    
    # Gets the weeks included in that month
    def in_month(date)
      date = Date.parse(date.strftime('%Y%m01'))
      5.times                                                    \
       .inject([Week.current(date)]) { |m, i| m << m.last.next } \
       .delete_if { |w| w.start.month != date.month && w.finish.month != date.month }
    end
    
    # returns all the weeks since the specified date
    def since(date)
      weeks = [Week.current(date)]
      until weeks.last.start >= Week.current.start
        weeks << weeks.last.next
      end
      weeks.reverse
    end
  end

  # Starts a week from a date
  def initialize(start)
    @start = Time.parse(start.strftime('%Y-%m-%d'))
    @finish = @start + SixDays
  end
  
  # Checks a date is included in the week
  def include?(date)
    date = Time.parse(date.to_s)
    date >= start && date <= finish
  end
  
  # Returns the previous week
  def previous
    Week.new(start - SevenDays)
  end
 
  def next
    Week.new(start + SevenDays)
  end
      
  def ==(other)
    !other.nil? && @start == other.start && @finish == other.finish
  end

  alias eql? ==
  
  def <=>(other)
    other.start <=> @start
  end
end