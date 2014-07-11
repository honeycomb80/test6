# Builds all fixed date categories
task :set_dates => :environment do
  require 'date'

  def make_week(date)
    date = Date.parse(date)
    last_updated = Week.order('created_at DESC').take
    unless last_updated.nil?
      date = last_updated.week
    end
    until date > Date.today
      Week.create(week: date)
      date += 7
    end
  end

  def make_month(date)
    month = Date.parse(date).month
    year = Date.parse(date).year
    date = Date.new(year,month,1)
    last_updated = Month.order('created_at DESC').take
    unless last_updated.nil?
      date = last_updated.month
    end
    until date > Date.today
      Month.create(month: date)
      date = date >> 1
    end
  end

  def make_year(date)
    date = Date.parse(date).year
    last_updated = Year.order('created_at DESC').take
    unless last_updated.nil?
      date = last_updated.year
    end
    until date > Date.today.year
      Year.create(year: date)
      date += 1
    end
  end

date = '20050611'
date2 = '20050605'
make_week(date2)
make_month(date)
make_year(date)

end