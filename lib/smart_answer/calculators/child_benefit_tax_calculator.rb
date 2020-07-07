module SmartAnswer::Calculators
  class ChildBenefitTaxCalculator
    attr_accessor :children_count,
                  :tax_year,
                  :is_part_year_claim,
                  :part_year_children_count,
                  :income_details,
                  :allowable_deductions

    def initialize(children_count: 0,
                   tax_year: nil,
                   is_part_year_claim: nil,
                   part_year_children_count: 0,
                   income_details: 0,
                   allowable_deductions: 0)

      @children_count = children_count
      @tax_year = tax_year
      @is_part_year_claim = is_part_year_claim
      @part_year_children_count = part_year_children_count
      @income_details = income_details
      @allowable_deductions = allowable_deductions
    end
  end
end
