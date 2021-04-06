module SmartAnswer
  class CalculateStatutorySickPayFlow < Flow
    def define
      content_id "1c676a9e-0424-4ebb-bab8-d8cb8d2fc6f8"
      name "calculate-statutory-sick-pay"

      status :published
      satisfies_need "4784e91e-359c-4f88-aa9e-316392945c85"

      # Question 1
      checkbox_question :is_your_employee_getting? do
        option :statutory_maternity_pay
        option :maternity_allowance
        option :statutory_paternity_pay
        option :statutory_adoption_pay
        option :statutory_parental_bereavement_pay
        option :shared_parental_leave_and_pay

        on_response do |response|
          self.calculator = Calculators::StatutorySickPayCalculator.new
          calculator.other_pay_types_received = response.split(",")
        end

        next_node do
          if calculator.already_getting_maternity_pay?
            outcome :already_getting_maternity
          else
            question :coronavirus_related?
          end
        end
      end

      # Question 2
      radio :coronavirus_related? do
        option :yes
        option :no

        on_response do |response|
          calculator.coronavirus_related = response == "yes"
        end

        next_node do
          if calculator.coronavirus_related
            question :coronavirus_gp_letter?
          else
            question :employee_tell_within_limit?
          end
        end
      end

      # Question 2.1
      radio :coronavirus_gp_letter? do
        option :yes
        option :no

        on_response do |response|
          calculator.coronavirus_gp_letter = response == "yes"
        end

        next_node do
          if calculator.coronavirus_gp_letter
            question :employee_tell_within_limit?
          else
            question :coronavirus_self_or_cohabitant?
          end
        end
      end

      # Question 2.2
      radio :coronavirus_self_or_cohabitant? do
        option :self
        option :cohabitant

        on_response do |response|
          calculator.has_coronavirus = response == "self"
          calculator.cohabitant_has_coronavirus = response == "cohabitant"
        end

        next_node do
          question :employee_tell_within_limit?
        end
      end

      # Question 3
      radio :employee_tell_within_limit? do
        option :yes
        option :no

        on_response do |response|
          calculator.enough_notice_of_absence = response == "yes"
        end

        next_node do
          question :employee_work_different_days?
        end
      end

      # Question 4
      radio :employee_work_different_days? do
        option :yes
        option :no

        next_node do |response|
          case response
          when "yes"
            outcome :not_regular_schedule # Answer 4
          when "no"
            question :first_sick_day? # Question 4
          end
        end
      end

      # Question 5
      date_question :first_sick_day? do
        from { Date.new(2011, 1, 1) }
        to { Calculators::StatutorySickPayCalculator.year_of_sickness }

        on_response do |response|
          calculator.sick_start_date = response
        end

        validate_in_range

        next_node do
          question :last_sick_day?
        end
      end

      # Question 6
      date_question :last_sick_day? do
        from { Date.new(2011, 1, 1) }
        to { Calculators::StatutorySickPayCalculator.year_of_sickness }

        on_response do |response|
          calculator.sick_end_date = response
        end

        validate_in_range

        validate do
          calculator.valid_last_sick_day?
        end

        next_node do
          if calculator.valid_period_of_incapacity_for_work?
            question :has_linked_sickness?
          else
            outcome :must_be_sick_for_4_days
          end
        end
      end

      # Question 7
      radio :has_linked_sickness? do
        option :yes
        option :no

        on_response do |response|
          case response
          when "yes"
            calculator.has_linked_sickness = true
          when "no"
            calculator.has_linked_sickness = false
          end
        end

        next_node do
          if calculator.has_linked_sickness
            question :linked_sickness_start_date?
          else
            question :paid_at_least_8_weeks?
          end
        end
      end

      # Question 7.1
      date_question :linked_sickness_start_date? do
        from { Date.new(2010, 1, 1) }
        to { Calculators::StatutorySickPayCalculator.year_of_sickness }

        on_response do |response|
          calculator.linked_sickness_start_date = response
        end

        validate_in_range

        validate :error_linked_sickness_must_be_before do
          calculator.valid_linked_sickness_start_date?
        end

        next_node do
          question :linked_sickness_end_date?
        end
      end

      # Question 7.2
      date_question :linked_sickness_end_date? do
        from { Date.new(2010, 1, 1) }
        to { Calculators::StatutorySickPayCalculator.year_of_sickness }

        on_response do |response|
          calculator.linked_sickness_end_date = response
        end

        validate_in_range

        validate :error_must_be_within_eight_weeks do
          calculator.within_eight_weeks_of_current_sickness_period?
        end

        validate :error_must_be_at_least_1_day_before_first_sick_day do
          calculator.at_least_1_day_before_first_sick_day?
        end

        validate :error_must_be_valid_period_of_incapacity_for_work do
          calculator.valid_linked_period_of_incapacity_for_work?
        end

        next_node do
          question :paid_at_least_8_weeks?
        end
      end

      # Question 8.1
      radio :paid_at_least_8_weeks? do
        option :eight_weeks_more
        option :eight_weeks_less
        option :before_payday

        on_response do |response|
          calculator.eight_weeks_earnings = response
        end

        next_node do
          if calculator.paid_at_least_8_weeks_of_earnings?
            question :how_often_pay_employee_pay_patterns? # Question 7.2
          elsif calculator.paid_less_than_8_weeks_of_earnings?
            question :total_earnings_before_sick_period? # Question 10
          elsif calculator.fell_sick_before_payday?
            question :how_often_pay_employee_pay_patterns? # Question 7.2
          end
        end
      end

      # Question 8.2
      radio :how_often_pay_employee_pay_patterns? do
        option :weekly
        option :fortnightly
        option :every_4_weeks
        option :monthly
        option :irregularly

        on_response do |response|
          calculator.pay_pattern = response
        end

        next_node do
          if calculator.paid_at_least_8_weeks_of_earnings?
            question :last_payday_before_sickness? # Question 8
          else
            question :pay_amount_if_not_sick? # Question 9
          end
        end
      end

      # Question 9
      date_question :last_payday_before_sickness? do
        from { Date.new(2010, 1, 1) }
        to { Calculators::StatutorySickPayCalculator.year_of_sickness }
        validate_in_range

        on_response do |response|
          calculator.relevant_period_to = response
        end

        validate do
          calculator.valid_last_payday_before_sickness?
        end

        next_node do
          question :last_payday_before_offset?
        end
      end

      # Question 9.1
      date_question :last_payday_before_offset? do
        from { Date.new(2010, 1, 1) }
        to { Calculators::StatutorySickPayCalculator.year_of_sickness }
        validate_in_range

        on_response do |response|
          calculator.relevant_period_from = response + 1.day
        end

        validate do
          calculator.valid_last_payday_before_offset?
        end

        next_node do
          question :total_employee_earnings?
        end
      end

      # Question 9.2
      money_question :total_employee_earnings? do
        on_response do |response|
          calculator.total_employee_earnings = response
        end

        next_node do
          question :usual_work_days?
        end
      end

      # Question 10
      money_question :pay_amount_if_not_sick? do
        on_response do |response|
          calculator.relevant_contractual_pay = response
        end

        next_node do
          question :contractual_days_covered_by_earnings?
        end
      end

      # Question 10.1
      value_question :contractual_days_covered_by_earnings? do
        on_response do |response|
          calculator.contractual_days_covered_by_earnings = response
        end

        validate :must_be_a_number_of_days do
          calculator.valid_contractual_days_covered_by_earnings?
        end

        next_node do
          question :usual_work_days?
        end
      end

      # Question 11
      money_question :total_earnings_before_sick_period? do
        on_response do |response|
          calculator.total_earnings_before_sick_period = response
        end

        next_node do
          question :days_covered_by_earnings?
        end
      end

      # Question 11.1
      value_question :days_covered_by_earnings? do
        on_response do |response|
          calculator.days_covered_by_earnings = response.to_i
        end

        next_node do
          question :usual_work_days?
        end
      end

      # Question 12
      checkbox_question :usual_work_days? do
        %w[1 2 3 4 5 6 0].each { |n| option n.to_s }

        on_response do |response|
          calculator.days_of_the_week_worked = response.split(",")
        end

        next_node do
          if calculator.not_earned_enough?
            outcome :not_earned_enough
          elsif calculator.maximum_entitlement_reached?
            outcome :maximum_entitlement_reached # Answer 8
          elsif calculator.entitled_to_sick_pay?
            outcome :entitled_to_sick_pay # Answer 6
          elsif calculator.maximum_entitlement_reached_v2?
            outcome :maximum_entitlement_reached # Answer 8
          else
            outcome :not_entitled_3_days_not_paid # Answer 7
          end
        end
      end

      # Answer 1
      outcome :already_getting_maternity

      # Answer 2
      outcome :must_be_sick_for_4_days

      # Answer 4
      outcome :not_regular_schedule

      # Answer 5
      outcome :not_earned_enough

      # Answer 6
      outcome :entitled_to_sick_pay

      # Answer 7
      outcome :not_entitled_3_days_not_paid

      # Answer 8
      outcome :maximum_entitlement_reached
    end
  end
end
