require 'smart_answer/calculators/passport_and_embassy_data_query'

module SmartdownPlugins
  module OverseasPassportsSpike

    def self.north_korea?(country)
      country == 'north-korea'
    end

    def self.ips_application?(passport_country)
      location = passport_country.value
      if passport(location)
        passport_type = passport(location)['type']
        %w{ips_application_1 ips_application_2 ips_application_3}.include?(passport_type)
      end
    end

    def self.fco_application?(passport_country)
      location = passport_country.value
      if passport(location)
        passport(location)['type'] == 'pretoria_south_africa'
      end
    end

    def self.ips_application_result_online?(passport_country)
      !!passport(passport_country.value)['online_application']
    end

    def self.waiting_time(passport_country, application_action)
      location = passport_country.value
      if passport(location)
        passport(location)[application_action.value].gsub '_', ' '
      end
    end

    def self.replacing_ips_1?(passport_country, application_action)
      application_action.value == 'replacing' &&
        ips_number(passport_country.value) == '1' &&
        ips_docs_number(passport_country.value) == '1'
    end

    private

    def self.passport(passport_country)
      data_query.find_passport_data(passport_country)
    end

    def self.ips_number(passport_country)
      passport(passport_country)['type'].split('_')[2]
    end

    def self.ips_docs_number(passport_country)
      passport(passport_country)['group'].split('_')[3]
    end

    def self.ips_1?(passport_country)
      ips_number(passport_country.value) == '1'
    end

    def self.ips_2?(passport_country)
      ips_number(passport_country.value) == '2'
    end

    def self.ips_3?(passport_country)
      ips_number(passport_country.value) == '3'
    end

    def self.ips_doc_1(passport_country)
      ips_docs_number(passport_country.value) == '1'
    end

    def self.ips_doc_2(passport_country)
      ips_docs_number(passport_country.value) == '2'
    end

    def self.ips_doc_3(passport_country)
      ips_docs_number(passport_country.value) == '3'
    end

    def self.data_query
      SmartAnswer::Calculators::PassportAndEmbassyDataQuery.new
    end

  end
end
