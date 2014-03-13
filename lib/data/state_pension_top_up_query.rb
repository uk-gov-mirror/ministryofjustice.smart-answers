#OLD VERSION
# class StatePensionDate < Struct.new(:gender, :start_date, :end_date, :pension_date)
class StatePensionDate < Struct.new(:gender, :age, :age_rate)
  def match?(dob, sex)
    same_gender?(sex) and born_in_range?(dob)
  end

#WE NEED THIS
  def same_gender?(sex)
    gender == sex or :both == gender
  end

#WE PROBABLY NEED THIS
  def born_in_range?(dob)
    dob >= start_date and dob <= end_date
  end
end


#WE NEED TO MODIFY THIS
class StatePensionTopUpQuery < Struct.new(:dob, :gender)
  def self.find(dob, gender)
    state_pension_query = new(dob, gender)
    result = state_pension_query.run
    state_pension_query.account_for_leap_year(result.pension_date)
  end
#we need to think about 
  def run
    state_pension_dates.find{|p| p.match?(dob, gender)}
  end

  # Handle the case where the person's d.o.b. is 29th Feb
  # on a leap year and that the pension elligibility date falls
  # on a non-leap year. ActiveSupport will helpfully adjust the 
  # date back to 28th Feb, but the calculation should forward to
  # the 1st March according to DWP rules.
  #
  #LEAP YEAR CHECK? WE PROBABLY DO NOT NEED THIS
  def account_for_leap_year(date)
    if leap_year_date?(dob) and !leap_year_date?(date) 
      date += 1
    end
    date
  end
  
  def leap_year_date?(date)
    date.month == 2 and date.day == 29
  end

#WE PROBABLY DO NOT NEED THIS
  # def state_pension_dates
  #   pension_dates_static + pension_dates_dynamic
  # end

#WE PROBABLY DO NOT NEED THIS
  # def pension_dates_dynamic
  #   [
  #     StatePensionDate.new(:female, Date.new(1890,01,01), Date.new(1950, 04, 05), 60.years.since(dob)),
  #     StatePensionDate.new(:male, Date.new(1890,01,01), Date.new(1953, 12, 05), 65.years.since(dob)),
  #     StatePensionDate.new(:both, Date.new(1954,10,06), Date.new(1968, 04, 05), 66.years.since(dob)),
  #     StatePensionDate.new(:both, Date.new(1969,04,06), Date.new(1977, 04, 05), 67.years.since(dob)),
  #     StatePensionDate.new(:both, Date.new(1978,04,06), Date.today + 1, 68.years.since(dob))
  #   ]
  # end
  
  
#CHANGED TO NEW VERSION
  # def pension_dates_static
  #   @@pension_dates_static ||= YAML.load_file(Rails.root.join("lib", "data", "state_pension_top_up_dates.yml"))
  # end
  def top_up_rates
    @@top_up_rates ||= YAML.load_file(Rails.root.join("lib", "data", "state_pension_top_up_dates.yml"))
  end
end
