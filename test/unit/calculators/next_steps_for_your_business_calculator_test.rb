require_relative "../../test_helper"

module SmartAnswer::Calculators
  class NextStepsForYourBusinessCalculatorTest < ActiveSupport::TestCase
    setup do
      @calculator = NextStepsForYourBusinessCalculator.new
    end

    context "#company_exists?" do
      should "return true if company profile is present" do
        @client = mock
        @client.stubs(:company)
          .with("123456789")
          .returns({ "company_name" => "BUSINESS NAME LTD" })

        CompaniesHouse::Client.stubs(:new).returns(@client)

        @calculator.crn = "123456789"
        assert @calculator.company_exists?
      end

      should "return false if company profile not found" do
        @client = mock
        @client.stubs(:company)
          .with("123456789")
          .raises(CompaniesHouse::NotFoundError, "Not found")

        CompaniesHouse::Client.stubs(:new).returns(@client)

        @calculator.crn = "123456789"
        assert_not @calculator.company_exists?
      end
    end

    context "#company_name" do
      should "return the company name" do
        @client = mock
        @client.stubs(:company)
          .with("123456789")
          .returns({ "company_name" => "BUSINESS NAME LTD" })

        CompaniesHouse::Client.stubs(:new).returns(@client)

        @calculator.crn = "123456789"
        assert_equal "BUSINESS NAME LTD", @calculator.company_name
      end

      should "return the nil if request not successful" do
        @client = mock
        @client.stubs(:company)
          .with("123456789")
          .raises(CompaniesHouse::APIError, "Request error")

        CompaniesHouse::Client.stubs(:new).returns(@client)

        @calculator.crn = "123456789"
        assert_nil @calculator.company_name
      end
    end
  end
end
