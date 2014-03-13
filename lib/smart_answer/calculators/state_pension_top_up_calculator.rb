module SmartAnswer::Calculators
  class StatePensionTopUpCalculator 

    attr_reader :dob

    def initialize(answers)
      @dob = DateTime.parse(answers[:dob])
    end

    def age_rates(age)
      data['age_rates'][age]
    end

    def over_100_years_old?
      dob < 100.years.ago
    end
    
    def age_at_payment (dob, date_of_payment)
        # Difference in years, less one if you have not had a birthday this year.
      age = date_of_payment.year - dob.year
      if (dob.month >  date_of_payment.month or  
          (dob.month >= date_of_payment.month and dob.day > date_of_payment.day))
        age -= 1
      end
      age
    end
    
    def age_at_payment_date?
      today = Date.today
      age = today.year - dob.year
      age
    end

#CREATE METHOD FOR INTEGERS

#CREATE METHOD FOR CALCULAT


    def self.age_rate_data
      @age_rate_data ||= YAML.load_file(Rails.root.join("lib", "data", "pension_top_up_data.yml"))
    end
  end
end