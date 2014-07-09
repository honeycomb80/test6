def make_week(date)
  date = Date.parse(date)
  until date > Date.today
    # Week.create(week: date)
    date += 7
    puts date
  end
end

def make_month(date)
  month = Date.parse(date).month
  year = Date.parse(date).year
  date = Date.new(year,month,1)
  until date > Date.today
    # Month.create(month: date)
    date = date >> 1
    puts date
  end
end

def make_year(date)
  date = Date.parse(date).year
  until date == Date.today.year
    # Year.create(year: date)
    date += 1
    puts date
  end
end
