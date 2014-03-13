require_relative '../../test_helper'
require_relative 'flow_test_helper'

class CalculateStatePensionTopUpTest < ActiveSupport::TestCase
  include FlowTestHelper

  setup do
    setup_for_testing_flow 'calculate-state-pension-top-up'
  end

  should "ask the gender" do
    assert_current_node :gender?
  end

  context "male application" do
    setup do
      add_response :male
      # assert_state_variable :age_rates, 0
    end

    should "ask for date of birth" do
      assert_current_node :dob?
    end

    context "user age < 100" do
      setup do
        add_response Date.parse('1980-02-02')
      end

      should "ask how much per week" do
        assert_current_node :how_much_per_week?
        # pension_top_up_calc['age_rate']
      end

      context "give value" do
        setup do
          add_response 10
        end
        
        should "bring you to date of payment question" do
          assert_current_node :date_of_lump_sum_payment?
        end
          
        context "go to final outcome with calculations" do
          setup do 
            add_response Date.parse('2015-10-01')
          end
            
          should "show final outcome" do
            assert_current_node :outcome_result
          end
        end
      end
        
      #   should "ask when they wish to pay" do
      #     add_response (Date.today + 1).to_s
      #   end
      # end
    end  
    context "user age > 100" do
      setup do
        add_response Date.parse('1900-02-02')
      end

      should "go to age limit reached outcome" do
        assert_current_node :outcome_age_limit_reached_now
      end
    end
  end
  
  
  context "female application" do
  end # female application
end # class end