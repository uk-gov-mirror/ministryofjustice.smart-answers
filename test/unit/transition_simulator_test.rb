# coding:utf-8

require_relative '../test_helper'

class TransitionSimulatorTest < ActiveSupport::TestCase
  setup do
    @flow = SmartAnswer::Flow.new do
      multiple_choice :q1 do
        option :yes => :o1
        option :no => :o1
      end

      outcome :o1
    end
  end

  test "calculates the sum of all transitions between each node pair" do
    data = {
      "/check-uk-visa/y/yes" => 1,
      "/check-uk-visa/y/no" => 1
    }

    transitions = TransitionSimulator.new(@flow).simulate(data)
    expected_transition_map = {
      [:q1, :o1] => 2
    }
    assert_equal expected_transition_map, transitions
  end
end
