module SmartdownPlugins
  module Fr

    class << self

      def fee_under_capital_minimum? fee
        fee <= 1000
      end

      def and_your_partner(relationship)
        if relationship == 'couple'
          ' and your partner'
        end
      end

      def or_your_partner(relationship)
        if relationship == 'couple'
          ' or your partner'
        end
      end

      def and_your_partners(relationship)
        if relationship == 'couple'
          " and your partner's"
        end
      end

      def disposable_capital_threshold(under_age_threshold, fee=nil)

        threshold = if under_age_threshold == 'over_age_threshold'
                      16000
                    else
                      if fee <= 1000
                        3000
                      elsif fee > 1000 && fee <= 1335
                        4000
                      elsif fee > 1335 && fee <= 1665
                        5000
                      elsif fee > 1665 && fee <= 2000
                        6000
                      elsif fee > 2000 && fee <= 2330
                        7000
                      elsif fee > 2330 && fee <= 4000
                        8000
                      elsif fee > 4000 && fee <= 5000
                        10000
                      elsif fee > 5000 && fee <= 6000
                        12000
                      elsif fee > 6000 && fee <= 7000
                        14000
                      elsif fee > 7000
                        16000
                      end
                    end

        Smartdown::Model::Answer::Money.new(threshold).humanize
      end

      def monthly_income_threshold(relationship, dependent_children=nil)
        threshold = if relationship == 'couple'
                      5245
                    else
                      5085
                    end

        if dependent_children
          number_of_children = dependent_children.to_i
          adjustment = (number_of_children * 245)
          threshold += adjustment
        end

        Smartdown::Model::Answer::Money.new(threshold).humanize
      end

    end
  end
end
