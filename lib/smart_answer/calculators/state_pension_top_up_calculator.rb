module SmartAnswer::Calculators
  class StatePensionTopUpCalculator 

    attr_reader :dob, :dop

    def initialize(answers)
      @dob = DateTime.parse(answers[:dob])
      # @dop = DateTime.parse(answers[:dop])
    end
    
    def starter(answers)
      @dop = (answers)
    end
      
    def age_rates(age_at_payment)
      data['age_rates'][age_at_payment]
    end

    def over_100_years_old?
      dob < 100.years.ago
    end
    
    def over_100_years_old_at_payment?
      (dop - dob) > 100.years
    end
      
    
    # def over_100_years_old_at_payment(date_of_payment)
    #   dob < date_of_payment - 100
    # end
    #brendan jack method
    # def age_at_payment?
    #   # age = date_of_payment.year - dob.year
    #   # if (dob.month >  date_of_payment.month or  
    #   #     (dob.month >= date_of_payment.month and dob.day > date_of_payment.day))
    #   #   age -= 1
    #   # end
    #   age = dop + 100.years
    # end
    
    #aaron method
    # def age_today?
    #   today = Date.today
    #   age = today.year - dob.year
    #   age
    # end
    
    # #new method for checking age at payment
    # def age_at_payment_date?
    #   today = Date.today
    #   age_at_payment = dob.year - date_of_payment.year
    #   age_at_payment
    # end

#CREATE METHOD FOR INTEGERS

#CREATE METHOD FOR CALCULAT


    def self.age_rate_data
      @age_rate_data ||= YAML.load_file(Rails.root.join("lib", "data", "pension_top_up_data.yml"))
    end
  end
end