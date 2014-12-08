require 'smart_answer/calculators/passport_and_embassy_data_query'

module SmartdownPlugins
  module OverseasPassportsSpike

    def self.north_korea?(country)
      country == 'north-korea'
    end

    def self.ips_application?(current_location)
      if passport(current_location)
        passport_type = passport(current_location)['type']
        %w{ips_application_1 ips_application_2 ips_application_3}.include?(passport_type)
      end
    end

    def self.fco_application?(current_location)
      if passport(current_location)
        passport(current_location)['type'] == 'pretoria_south_africa'
      end
    end

    def self.ips_application_result_online?(current_location)
       !!passport(current_location)['online_application']
    end

    def self.passport(current_location)
      data_query.find_passport_data(current_location)
    end

    def self.waiting_time(current_location)
      if passport(current_location)
        passport(current_location)[application_action]
      end
    end

    private

    def self.data_query
      SmartAnswer::Calculators::PassportAndEmbassyDataQuery.new
    end

  end
end
