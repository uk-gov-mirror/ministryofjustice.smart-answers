# -*- coding: utf-8 -*-
status :draft
satisfies_need ""

# calc = SmartAnswer::Calculators::StatePensionTopUpCalculator.new

# Q1
multiple_choice :gender? do
  save_input_as :gender

  option :male
  option :female

  calculate :age_rates do 
    # pension_top_up_calc['age_rate']
  end
  
  next_node :dob?
end


# Q2
date_question :dob? do
  from { 130.years.ago }
  to { Date.today }
  

  save_input_as :dob

  ### needs to work out age here
  # calculate :age do
  #   Calculators::StatePensionTopUpCalculator.new(
  #     dob: dob)
  # end
  
  next_node do |response|
    # raise InvalidResponse if (Date.parse(response) + 100) < Date.today

    # calc = Calculators::StatePensionAmountCalculatorV2.new(
    #   gender: gender, dob: response)
    # date_of_birth = response
    # date_today = Date.today
    # raise InvalidResponse if response < (date_today - 100)
    #IF THIS IS ACTIVE, IT DOES NOT LET YOU LEAVE THE QUESTION 
    
    calc = Calculators::StatePensionTopUpCalculator.new(dob: response)
    
    if calc.over_100_years_old?
      :outcome_age_limit_reached
    elsif (response < ('1951-04-06') and gender == "male") or (response < ('1953-04-06') and gender == "female")
      :outcome_pension_age_not_reached
    else
      :how_much_per_week?
    end
  end
end


# Q3
value_question :how_much_per_week? do
  save_input_as :weekly_amount

  next_node :date_of_lump_sum_payment?
end

# Q4
date_question :date_of_lump_sum_payment? do
  from { Date.parse('2015-10-01') }
  to { Date.parse('2017-04-01') }

  save_input_as :date_of_payment

  # calculate :age_at_date_of_payment do 
  #   (responses.last - dob)
  # end
  next_node :outcome_result
  # next_node do |response|
  #   a = response.year - dob.year
  #   if (dob.month > response.month) or (dob.month >= response.month and dob.day > response.day)
  #     a = a - 1 
  #   end
    
  #   if a > '0101-00-00' ### implement month and day
  #     :outcome_age_limit_reached
  #   else
      # :outcome_result
  #   end
  # end
end

## Outcomes
#A1
outcome :outcome_result do
  
  # precalculate :age_at_date_of_payment do 
  #   "age_#{date_of_payment - dob}"
  # end
  
  # precalculate :lump_sum do
  #   pension_top_up_calc['age_rate']
  # end
  
end


#A2 
outcome :outcome_pension_age_not_reached

#A3
outcome :outcome_age_limit_reached