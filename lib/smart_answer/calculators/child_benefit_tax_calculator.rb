module SmartAnswer::Calculators
  class ChildBenefitTaxCalculator
    attr_accessor :children_count,
                  :tax_year,
                  :is_part_year_claim,
                  :part_year_children_count,
                  :income_details,
                  :allowable_deductions,
                  :other_allowable_deductions,
                  :part_year_claim_dates,
                  :child_index

    NET_INCOME_THRESHOLD = 50_000
    TAX_COMMENCEMENT_DATE = Date.parse("7 Jan 2013") # special case for 2012-13, only weeks from 7th Jan 2013 are taxable

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
      @part_year_claim_dates = HashWithIndifferentAccess.new
      @tax_years = tax_year_dates
      @child_index = 0
    end

    def self.tax_years
      child_benefit_data.each_with_object([]) do |(key), tax_year|
        tax_year << key
      end
    end

    def self.child_benefit_data
      @child_benefit_data ||= YAML.load_file(Rails.root.join("config/smart_answers/rates/child_benefit_rates.yml")).with_indifferent_access
    end

    def store_date(date_type, response)
      @part_year_claim_dates[child_index] = if @part_year_claim_dates[child_index].nil?
                                              { date_type => response }
                                            else
                                              @part_year_claim_dates[child_index].merge!({ date_type => response })
                                            end
    end
  end
end
