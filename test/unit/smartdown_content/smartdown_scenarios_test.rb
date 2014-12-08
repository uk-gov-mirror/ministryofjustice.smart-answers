require 'test_helper'
require 'gds_api/test_helpers/imminence'
require 'gds_api/test_helpers/worldwide'

class SmartdownScenariosTest < ActiveSupport::TestCase

  include GdsApi::TestHelpers::Imminence
  include GdsApi::TestHelpers::Worldwide

  class FakeWorldwideApi
    def initialize(world_locations)
      @world_locations = world_locations
    end

    attr_reader :world_locations

    def world_location(slug)
      @world_locations.with_subsequent_pages.find { |world_location|
        world_location.details.slug == slug.to_s
      }
    end

    def organisations_for_world_location(slug)
      []
    end
  end
  countries = [
        OpenStruct.new(slug: 'afghanistan', name: 'Afghanistan'),
        OpenStruct.new(slug: 'australia', name: 'Australia'),
        OpenStruct.new(slug: 'denmark', name: 'Denmark'),
        OpenStruct.new(slug: 'united-kingdom', name: 'United Kingdom'),
        OpenStruct.new(slug: 'germany', name: 'Germany'),
        OpenStruct.new(slug: 'iran', name: 'Iran'),
        OpenStruct.new(slug: 'sweden', name: 'Sweden'),
        OpenStruct.new(slug: 'vietnam', name: 'Vietnam'),
        OpenStruct.new(slug: 'holy-see', name: 'Holy See'),
        OpenStruct.new(slug: 'pakistan', name: 'Pakistan'),
        OpenStruct.new(slug: 'north-korea', name: 'North Korea'),
        OpenStruct.new(slug: 'united-arab-emirates', name: 'United Arab Emirates'),
        OpenStruct.new(slug: 'british-antarctic-territory', name: 'British Antartic Territory')
  ]
  world_location_array = countries.map do |country|
    OpenStruct.new(details: country, format: "World location")
  end
  world_locations = OpenStruct.new(:with_subsequent_pages => world_location_array)
  $worldwide_api = FakeWorldwideApi.new(world_locations)

  setup do
    imminence_has_areas_for_postcode("WC2B%206SE", [])
    imminence_has_areas_for_postcode("B1%201PW", [{ slug: "birmingham-city-council" }])
  end

  SmartdownAdapter::Registry::FLOW_REGISTRY_OPTIONS = {
    preload_flows: true,
    show_drafts: true,
    show_transitions: true,
  }

  smartdown_flows = SmartdownAdapter::Registry.instance.flows
  smartdown_flows.each do |smartdown_flow|
    smartdown_flow.scenario_sets.each do |scenario_set|
      scenario_set.scenarios.each_with_index do |scenario, scenario_index|
        description = scenario.description.empty? ? scenario_index+1 : scenario.description
        test "test_scenario_#{description}_in_set_#{scenario_set.name}_for flow_#{smartdown_flow.name}" do
          scenario.question_groups.each_with_index do |question_group, question_index|
            answers = scenario.question_groups.take(question_index).flatten.map(&:answer)
            question_names = question_group.map(&:name)
            questions_are_asked(smartdown_flow, answers, question_names)
          end
          answers = scenario.question_groups.flatten.map(&:answer)
          outcome_is_reached(smartdown_flow, answers, scenario.outcome)
        end
      end
    end
  end

  def questions_are_asked(flow, answers, question_names)
    assert_nothing_raised("Exception was thrown when running flow #{flow.name} with answers #{answers}") do
      state  = flow.state(true, answers)
      assert (state.current_node.is_a? Smartdown::Api::QuestionPage),
             "Expected a question when running flow #{flow.name} with answers #{answers}"
      current_question_names = state.current_node.questions.map(&:name).map(&:to_s)
      question_names.each do |question_name|
        assert current_question_names.include?(question_name),
               "In flow #{flow.name} with answers #{answers}, questions #{current_question_names} were reached but not #{question_name}"
      end
    end
  end

  def outcome_is_reached(flow, answers, outcome)
    #assert_nothing_raised("Exception was thrown when running flow #{flow.name} with answers #{answers}") do
      state  = flow.state(true, answers)
      assert (state.current_node.is_a? Smartdown::Api::Outcome),
             "Expected an outcome when running flow #{flow.name} with answers #{answers}"
      assert_equal outcome,
                   state.current_node.name,
                   "In flow #{flow.name} with answers #{answers}, outcome #{state.current_node.name} was reached and not #{outcome}"
    #end
  end

  $worldwide_api = GdsApi::Worldwide.new("https://www.gov.uk")
end

