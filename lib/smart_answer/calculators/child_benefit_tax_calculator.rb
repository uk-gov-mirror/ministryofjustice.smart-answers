module SmartAnswer::Calculators
  class ChildBenefitTaxCalculator
    attr_accessor :children_count,
                  :tax_year,
                  :is_part_year_claim,
                  :part_year_children_count,
                  :income_details,
                  :allowable_deductions,
                  :other_allowable_deductions

    NET_INCOME_THRESHOLD = 50_000
      TAX_COMMENCEMENT_DATE = Date.parse("7 Jan 2013") # special case for 2012-13, only weeks from 7th Jan 2013 are taxable

    START_YEAR = 2012
    END_YEAR = 1.year.from_now.year
    TAX_YEARS = (START_YEAR...END_YEAR).each_with_object({}) { |year, hash|
    hash[year.to_s] = [Date.new(year, 4, 6), Date.new(year + 1, 4, 5)]
    }.freeze

    def initialize(children_count: 0,
                  tax_year: nil,
                  is_part_year_claim: nil,
                  part_year_children_count: 0,
                  income_details: 0,
                  allowable_deductions: 0,
                  other_allowable_deductions: 0)

      @children_count = children_count
      @tax_year = tax_year
      @is_part_year_claim = is_part_year_claim
      @part_year_children_count = part_year_children_count
      @income_details = income_details
      @allowable_deductions = allowable_deductions
      @other_allowable_deductions = other_allowable_deductions

      @child_benefit_data = self.class.child_benefit_data
    end

    def tax_years
      @child_benefit_data.each_with_object(Array.new) do |(key), tax_year|
        tax_year << key
      end
    end

    def selected_tax_year(tax_year)
      @child_benefit_data.fetch(tax_year)
    end

    def first_child_rate_total(no_of_weeks)
      binding.pry
      @child_benefit_data.fetch(tax_year)
      # @child_benefit_data.first_child_rate * no_of_weeks
    end

    # def additional_child_rate_total(no_of_weeks, no_of_children)
    #   @child_benefit_rates.additional_child_rate * no_of_children * no_of_weeks
    # end
    #
    # def total_number_of_mondays(child_benefit_start_date, child_benefit_end_date)
    #   (child_benefit_start_date..child_benefit_end_date).count(&:monday?)
    # end


    def self.child_benefit_data
      @child_benefit_data ||= YAML.load_file(Rails.root.join("config/smart_answers/rates/child_benefit_rates.yml"))
    end
  end
end
