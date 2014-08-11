module Smartdown
  class Question < Node

    def has_hint?
      !!hint
    end

    # This only works for Multiple Choice for now
    # To be implemented properly once we have another question type and some kind of supertype?
    def hint
      question = elements.find{|element| element.is_a? Smartdown::Model::Element::MultipleChoice}
      question.hint
    end

    def prefix
      "prefix not currently possible"
    end

    def suffix
      "suffix not currently possible"
    end

    def subtitle
      "subtitle not currently possible"
    end

    #TODO: when error handling
    def error
    end

    #TODO
    def responses
    end

  end
end
