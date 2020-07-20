require_relative "../../test_helper"

require "smart_answer_flows/child-benefit-tax-calculator"

module SmartAnswer
  class ChildBenefitTaxCalculatorViewTest < ActiveSupport::TestCase
    setup do
      @flow = ChildBenefitTaxCalculatorFlow.build
    end

    # Q1
    context "when rendering how_many_children? question" do
      setup do
        question = @flow.node(:how_many_children?)
        @state = SmartAnswer::State.new(question)
        @presenter = ValueQuestionPresenter.new(question, @state)
      end

      should "display a useful error message when the number entered is bigger than 30" do
        @state.error = "valid_number_of_children"
        assert_match "Please enter number of children you're claiming for", @presenter.error
      end

      should "display hint text" do
        assert_equal "Number of children", @presenter.hint
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please answer this question", @presenter.error
      end
    end

    # Q2
    context "when rendering which_tax_year? question" do
      setup do
        question = @flow.node(:which_tax_year?)
        @state = SmartAnswer::State.new(question)
        @presenter = MultipleChoiceQuestionPresenter.new(question, @state)
      end

      should "have options with labels" do
        assert_equal({ "2012" => "2012 to 2013",
                       "2013" => "2013 to 2014",
                       "2014" => "2014 to 2015",
                       "2015" => "2015 to 2016",
                       "2016" => "2016 to 2017",
                       "2017" => "2017 to 2018",
                       "2018" => "2018 to 2019",
                       "2019" => "2019 to 2020",
                       "2020" => "2020 to 2021",
                      }, values_vs_labels(@presenter.options))
      end

      should "display hint text" do
        assert_equal "Tax years run from 6 April to 5 April the following year.", @presenter.hint
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Select a tax year", @presenter.error
      end
    end

    # Q3
    context "when rendering is_part_year_claim? question" do
      setup do
        question = @flow.node(:is_part_year_claim?)
        @state = SmartAnswer::State.new(question)
        @presenter = MultipleChoiceQuestionPresenter.new(question, @state)
      end

      should "have options with labels" do
        assert_equal({ "yes" => "Yes", "no" => "No" }, values_vs_labels(@presenter.options))
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please answer this question", @presenter.error
      end
    end

    # Q3a
    context "when rendering how_many_children_part_year? question" do
      setup do
        question = @flow.node(:how_many_children_part_year?)
        @state = SmartAnswer::State.new(question)
        @state.children_count = 3
        @presenter = ValueQuestionPresenter.new(question, @state)
      end

      should "display hint text" do
        assert_equal "Number of children", @presenter.hint
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please enter a number", @presenter.error
      end

      should "display a useful error message when the number entered is bigger than the total number of children entered" do
        @state.error = "valid_number_of_part_year_children"
        assert_match "The number of children you're claiming for part year for can't be more than the total number of children you're claiming for", @presenter.error
      end
    end

    # Q3b
    context "when rendering child_benefit_start? question" do
      setup do
        question = @flow.node(:child_benefit_start?)
        @state = SmartAnswer::State.new(question)
        @presenter = DateQuestionPresenter.new(question, @state)
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please enter a number", @presenter.error
      end

      should "display a useful error message when the date entered is not within the tax year selected" do
        @state.error = "valid_within_tax_year"
        assert_equal "Child Benefit start date must be within the tax year selected", @presenter.error
      end
    end

    # Q3c
    context "when rendering add_child_benefit_stop? question" do
      setup do
        question = @flow.node(:add_child_benefit_stop?)
        @state = SmartAnswer::State.new(question)
        @presenter = MultipleChoiceQuestionPresenter.new(question, @state)
      end

      should "have options with labels" do
        assert_equal({ "yes" => "Yes", "no" => "No" }, values_vs_labels(@presenter.options))
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please answer this question", @presenter.error
      end
    end

    # Q3d
    context "when rendering child_benefit_stop? question" do
      setup do
        question = @flow.node(:child_benefit_stop?)
        @state = SmartAnswer::State.new(question)
        @presenter = DateQuestionPresenter.new(question, @state)
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please enter a number", @presenter.error
      end

      should "display a useful error message when the date entered is not within the tax year selected" do
        @state.error = "valid_within_tax_year"
        assert_equal "Child Benefit stop date must be within the tax year selected", @presenter.error
      end
    end

    # Q4
    context "when rendering income_details? question" do
      setup do
        question = @flow.node(:income_details?)
        @state = SmartAnswer::State.new(question)
        @presenter = MoneyQuestionPresenter.new(question, @state)
      end

      # should "display hint text" do
      #   assert_equal "Number of children", @presenter.hint
      # end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please enter a number", @presenter.error
      end
    end

    # Q5
    context "when rendering add_allowable_deductions? question" do
      setup do
        question = @flow.node(:add_allowable_deductions?)
        @state = SmartAnswer::State.new(question)
        @presenter = MultipleChoiceQuestionPresenter.new(question, @state)
      end

      should "have options with labels" do
        assert_equal({ "yes" => "Yes", "no" => "No" }, values_vs_labels(@presenter.options))
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please answer this question", @presenter.error
      end
    end

    # Q5a
    context "when rendering allowable_deductions? question" do
      setup do
        question = @flow.node(:allowable_deductions?)
        @state = SmartAnswer::State.new(question)
        @presenter = MoneyQuestionPresenter.new(question, @state)
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please enter a number", @presenter.error
      end
    end

    # Q5b
    context "when rendering add_other_allowable_deductions? question" do
      setup do
        question = @flow.node(:add_other_allowable_deductions?)
        @state = SmartAnswer::State.new(question)
        @presenter = MultipleChoiceQuestionPresenter.new(question, @state)
      end

      should "have options with labels" do
        assert_equal({ "yes" => "Yes", "no" => "No" }, values_vs_labels(@presenter.options))
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please answer this question", @presenter.error
      end
    end

    # Q5c
    context "when rendering other_allowable_deductions? question" do
      setup do
        question = @flow.node(:other_allowable_deductions?)
        @state = SmartAnswer::State.new(question)
        @presenter = MoneyQuestionPresenter.new(question, @state)
      end

      should "have a default error message" do
        @state.error = "error-message"
        assert_equal "Please enter a number", @presenter.error
      end
    end

  private

    def values_vs_labels(options)
      options.each_with_object({}) { |o, h| h[o[:value]] = o[:label]; }
    end
  end
end
