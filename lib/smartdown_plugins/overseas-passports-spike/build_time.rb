module SmartdownPlugins
  module OverseasPassportsSpike

    EXCLUDED_COUNTRIES = %w(holy-see british-antarctic-territory)

    ### taken from smartdown_version_of_register_a_birth
    def self.world_locations
      country_select = SmartAnswer::Question::CountrySelect.new(
        'overseas-passports',
        :exclude_countries => EXCLUDED_COUNTRIES)

      country_hash = {}
      country_select.country_list.map do |country|
        country_hash[country.slug] = country.title
      end
      country_hash

    end

  end
end
