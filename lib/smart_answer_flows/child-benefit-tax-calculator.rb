module SmartAnswer
  class ChildBenefitTaxCalculatorFlow < Flow
    def define
      name 'child-benefit-tax-calculator'
      start_page_content_id "201fff60-1cad-4d91-a5bf-d7754b866b87"
      flow_content_id "26f5df1d-2d73-4abc-85f7-c09c73332693"
      status :draft

      # Q1
      multiple_choice :how_many_children? do
        option :"1"
        option :"2"
        option :"3"
        option :"4"
        option :"5"
        option :"6"
        option :"7"
        option :"8"
        option :"9"
        option :"10"

        save_input_as :children_count

        next_node do
          question :which_tax_year?
        end
      end

      # outcome :outcome_1
    end
  end
end
