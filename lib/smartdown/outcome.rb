module Smartdown
  class Outcome < Node

    def has_next_steps?
      !!next_steps
    end

    def next_steps
      next_step_element = elements.find{|element| element.is_a? Smartdown::Model::Element::NextSteps}
      if next_step_element
        GovspeakPresenter.new(next_step_element.content).html
      end
    end

  end
end
