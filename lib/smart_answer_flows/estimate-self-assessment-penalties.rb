module SmartAnswer
  class EstimateSelfAssessmentPenaltiesFlow < Flow
    def define
      content_id "32b54f44-fca1-4480-b13b-ddeb0b0238e1"
      name "estimate-self-assessment-penalties"
      status :published
      satisfies_need "e220b484-a097-4ed4-ae3d-ac982b10c8cd"

      radio :which_year? do
        option :"2013-14"
        option :"2014-15"
        option :"2015-16"
        option :"2016-17"
        option :"2017-18"
        option :"2018-19"
        option :"2019-20"

        on_response do |response|
          self.calculator = Calculators::SelfAssessmentPenalties.new
          calculator.tax_year = response
        end

        next_node do
          question :how_submitted?
        end
      end

      radio :how_submitted? do
        option :online
        option :paper

        on_response do |response|
          calculator.submission_method = response
        end

        next_node do
          question :when_submitted?
        end
      end

      date_question :when_submitted? do
        from { 3.years.ago(Time.zone.today) }
        to { 2.years.since(Time.zone.today) }

        on_response do |response|
          calculator.filing_date = response
        end

        validate { calculator.valid_filing_date? }

        next_node do
          question :when_paid?
        end
      end

      date_question :when_paid? do
        from { 3.years.ago(Time.zone.today) }
        to { 2.years.since(Time.zone.today) }

        on_response do |response|
          calculator.payment_date = response
        end

        validate { calculator.valid_payment_date? }

        next_node do
          if calculator.paid_on_time?
            outcome :filed_and_paid_on_time
          else
            question :how_much_tax?
          end
        end
      end

      money_question :how_much_tax? do
        on_response do |response|
          calculator.estimated_bill = response
        end

        next_node do
          outcome :late
        end
      end

      outcome :late

      outcome :filed_and_paid_on_time
    end
  end
end
