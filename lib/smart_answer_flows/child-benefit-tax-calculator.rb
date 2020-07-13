module SmartAnswer
  class ChildBenefitTaxCalculatorFlow < Flow
    def define
      name 'child-benefit-tax-calculator'
      start_page_content_id "201fff60-1cad-4d91-a5bf-d7754b866b87"
      flow_content_id "26f5df1d-2d73-4abc-85f7-c09c73332693"
      status :draft

      config = Calculators::ChildBenefitTaxConfiguration.new
      calculator = Calculators::ChildBenefitTaxCalculator.new
      # Q1
      multiple_choice :how_many_children? do
        (1..10).each do | children |
          option :"#{children}"
        end

        on_response do |response|
          calculator.children_count = response.to_i
        end

        next_node do
          question :which_tax_year?
        end
      end

      # Q2
      multiple_choice :which_tax_year? do
        calculator.tax_years.each do | tax_year |
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
      multiple_choice :how_many_children_part_year? do
        # precalculate :children_count do
        #   set_children_count(calculator.children_count)
        # end

        calculator.children_count.each do | children |
          option :"#{children}"
        end

        on_response do |response|
          self.part_year_children_count = [*"1"..response]
        end

        next_node do
          question ChildBenefitTaxCalculatorFlow.next_child_start_date_question(config.questions, part_year_children_count)
        end
      end

      # Q3b
      config.questions.each do |(_child, method)|
        date_question method do
          from { Date.new(2011, 1, 1) }
          to { Date.new(2021, 4, 5) }

          next_node do
            question ChildBenefitTaxCalculatorFlow.next_child_start_date_question(config.questions, part_year_children_count)
          end
        end
      end

      # Q4
      value_question :income_details? do
        save_input_as :income_details

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

    # def self.set_children_count(children_count)
    #   [*1..children_count]
    # end

    def self.next_child_start_date_question(children, part_year_children_count)
      children.fetch(part_year_children_count.shift, :income_details)
    end
  end
end
