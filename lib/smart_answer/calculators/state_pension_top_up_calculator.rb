require "data/state_pension_top_up_query"

module SmartAnswer::Calculators
  class StatePensionTopUpCalculator
    include ActionView::Helpers::TextHelper

    
    def self.age_rate_data
      @age_rate_data ||= YAML.load_file(Rails.root.join("lib", "data", "state_pension_top_up_dates.yml"))
    end
  
  end
end
