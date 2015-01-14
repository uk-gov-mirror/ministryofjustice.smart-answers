require 'smartdown/model/answer/money'
require 'smartdown/model/answer/date'

module SmartdownPlugins
  module FeeRemissionEligibility

    def self.your_partner(relationship)
      if relationship == 'couple'
        ' and your partner'
      end
    end

    def self.disposable_capital_threshold(under_age_threshold, claim_fee=nil)
      if under_age_threshold
        fee = claim_fee.to_f
        if fee <= 1000
          '3,000'
        elsif fee > 1000 && fee <= 1335
          '4,000'
        elsif fee > 1335 && fee <= 1665
          '5,000'
        elsif fee > 1665 && fee <= 2000
          '6,000'
        elsif fee > 2000 && fee <= 2330
          '7,000'
        elsif fee > 2330 && fee <= 4000
          '8,000'
        elsif fee > 4000 && fee <= 5000
          '10,000'
        elsif fee > 5000 && fee <= 6000
          '12,000'
        elsif fee > 6000 && fee <= 7000
          '14,000'
        elsif fee > 7000
          '16,000'
        end
      else
        '16,000'
      end
    end
  end
end
