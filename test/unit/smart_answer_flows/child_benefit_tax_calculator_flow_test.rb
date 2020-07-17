require_relative "../../test_helper"
require_relative "flow_unit_test_helper"

require "smart_answer_flows/child-benefit-tax-calculator"

module SmartAnswer
  class ChildBenefitTaxCalculatorFlowTest < ActiveSupport::TestCase
    context ChildBenefitTaxCalculatorFlow do
      include FlowUnitTestHelper

      setup do
        @calculator = Calculators::ChildBenefitTaxCalculator.new
        @flow = ChildBenefitTaxCalculatorFlow.build
      end

      should "start with how_many_children? question" do
        assert_equal :how_many_children?, @flow.start_state.current_node
      end

      # Q1
      context "when answering how_many_children? question" do
        setup do
          Calculators::ChildBenefitTaxCalculator.stubs(:new).returns(@calculator)
          setup_states_for_question(
            :how_many_children?,
            responding_with: "2",
          )
        end

        should "instantiate and store calculator" do
          assert_same @calculator, @new_state.calculator
        end

        should "store parsed response on calculator as children_count" do
          assert_equal 2, @calculator.children_count
        end

        should "go to which_tax_year? question" do
          assert_equal :which_tax_year?, @new_state.current_node
          assert_node_exists :which_tax_year?
        end
      end

      # Q2
      context "when answering which_tax_year? question" do
        setup do
          setup_states_for_question(
            :which_tax_year?,
            responding_with: "2012",
            initial_state: { calculator: @calculator },
          )
        end

        should "instantiate and store calculator" do
          assert_same @calculator, @new_state.calculator
        end

        should "store parsed response on calculator as tax_year" do
          assert_equal "2012", @calculator.tax_year
        end

        should "go to is_part_year_claim? question" do
          assert_equal :is_part_year_claim?, @new_state.current_node
          assert_node_exists :is_part_year_claim?
        end
      end

      # Q3
      context "when answering is_part_year_claim? question" do
        context "responding with yes" do
          setup do
            setup_states_for_question(
              :is_part_year_claim?,
              responding_with: "yes",
              initial_state: { calculator: @calculator },
            )
          end

          should "instantiate and store calculator" do
            assert_same @calculator, @new_state.calculator
          end

          should "go to how_many_children_part_year? question" do
            assert_equal :how_many_children_part_year?, @new_state.current_node
            assert_node_exists :how_many_children_part_year?
          end
        end

        context "responding with no" do
          setup do
            setup_states_for_question(
              :is_part_year_claim?,
              responding_with: "no",
              initial_state: { calculator: @calculator },
            )
          end

          should "instantiate and store calculator" do
            assert_same @calculator, @new_state.calculator
          end

          should "go to income_details? question" do
            assert_equal :income_details?, @new_state.current_node
            assert_node_exists :income_details?
          end
        end
      end
    end
  end
end
