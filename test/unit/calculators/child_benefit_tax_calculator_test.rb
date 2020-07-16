require_relative "../../test_helper"

module SmartAnswer::Calculators
  class ChildBenefitTaxCalculatorTest < ActiveSupport::TestCase
    context ChildBenefitTaxCalculator do
      context "full year children only" do
        context "calculating the number of weeks/Mondays" do
        # line 247 in calculators unit/calculators/child_benefit_tax_calculator_test.rb
          context "for the full tax year 2012/2013" do
            should "calculate there are 13 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2012",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 13, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2013/2014" do
            should "calculate there are 52 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2013",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 52, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2014/2015" do
            should "calculate there are 52 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2014",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 52, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2015/2016" do
            should "calculate there are 53 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2015",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 53, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2016/2017" do
            should "calculate there are 52 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2016",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 52, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2017/2018" do
            should "calculate there are 52 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2017",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 52, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2018/2019" do
            should "calculate there are 52 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2018",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 52, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2019/2020" do
            should "calculate there are 52 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2019",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 52, calc.total_number_of_mondays(start_date, end_date)
            end
          end

          context "for the full tax year 2020/2021" do
            should "calculate there are 53 Mondays" do
              calc = ChildBenefitTaxCalculator.new(
                tax_year: "2020",
                children_count: "1",
                is_part_year_claim: "no",
              )
              start_date = calc.child_benefit_start_date
              end_date = calc.child_benefit_end_date
              assert_equal 53, calc.total_number_of_mondays(start_date, end_date)
            end
          end
        end
      end

      context "calculating child benefits received" do
        context "for the tax year 2012" do
          should "give the total amount of benefits received for a full tax year 2012" do
            assert_equal 263.9, ChildBenefitTaxCalculator.new(
              tax_year: "2012",
              children_count: 1,
              is_part_year_claim: "no",
            ).benefits_claimed_amount.round(2)
          end

          should "give the total amount of benefits received for a partial tax year" do
            calc = ChildBenefitTaxCalculator.new(
              tax_year: "2012",
              children_count: 1,
              is_part_year_claim: "yes",
              part_year_children_count: 1
            )
            calc.child_benefit_start_dates = {
              "0" => {
                start_date: Date.parse("2012-06-01"),
                end_date: Date.parse("2013-06-01")
                }
              }
            assert_equal 263.9, calc.benefits_claimed_amount.round(2)
          end
        end
      end
    end
  end
end
