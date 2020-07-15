module SmartAnswer
  class ChildBenefitTaxCalculatorFlow < Flow
    def define
      name 'child-benefit-tax-calculator'
      start_page_content_id "201fff60-1cad-4d91-a5bf-d7754b866b87"
      flow_content_id "26f5df1d-2d73-4abc-85f7-c09c73332693"
      status :draft

      # calculator = Calculators::ChildBenefitTaxCalculator.new
      # Q1
      multiple_choice :how_many_children? do
        (1..10).each do | children |
          option :"#{children}"
        end

        on_response do |response|
          self.calculator = Calculators::ChildBenefitTaxCalculator.new
          calculator.children_count = response.to_i
        end

        next_node do
          question :which_tax_year?
        end
      end

      # Q2
      multiple_choice :which_tax_year? do
        Calculators::ChildBenefitTaxCalculator.tax_years.each do | tax_year |
          option :"#{tax_year}"
        end

        on_response do |response|
          calculator.tax_year = response
        end

        next_node do
          question :is_part_year_claim?
        end
      end

      # Q3
      multiple_choice :is_part_year_claim? do
        option :"yes"
        option :"no"

        save_input_as :is_part_year_claim

        next_node do |response|
          if response == "yes"
            question :how_many_children_part_year?
          else
            question :income_details?
          end
        end
      end

      # Q3a
      value_question :how_many_children_part_year?, parse: Integer do
        on_response do |response|
          calculator.part_year_children_count = response
        end

        validate(:valid_number_of_children) do
          calculator.valid_number_of_children?
        end

        next_node do
          question :child_benefit_start?
        end
      end

      # Q3b
      date_question :child_benefit_start? do
        from { Date.new(2011, 1, 1) }
        to { Date.new(2021, 4, 5) }

        on_response do |response|
          calculator.store_date(:start_date, response)
        end

        next_node do
          question :child_benefit_stop?
        end
      end
    
      # Q3c
      date_question :child_benefit_stop? do
        from { Date.new(2011, 1, 1) }
        to { Date.new(2021, 4, 5) }

        on_response do |response|
          calculator.store_date(:end_date, response)
        end

        next_node do
          calculator.child_index += 1
          if calculator.child_index < calculator.part_year_children_count
            question :child_benefit_start?
          else
            question :income_details?
          end
        end
      end

      # Q4
      value_question :income_details? do
        on_response do |response|
          calculator.income_details = response.to_i
          calculator.format_income
        end

        validate :error_outside_range do
          calculator.valid_income?
        end

        next_node do |response|
          question :allowable_deductions?
        end
      end

      # Q5a
      value_question :allowable_deductions? do
        save_input_as :allowable_deductions

        next_node do |response|
          question :other_allowable_deductions?
        end
      end

      # Q5b
      value_question :other_allowable_deductions? do
        save_input_as :other_allowable_deductions

        next_node do |response|
          outcome :outcome_1
        end
      end

      outcome :outcome_1
    end
  end
end
