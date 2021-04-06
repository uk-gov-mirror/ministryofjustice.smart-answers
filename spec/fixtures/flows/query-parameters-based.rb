module SmartAnswer
  class QueryParametersBasedFlow < Flow
    def define
      name "query-parameters-based"
      satisfies_need "dccab509-bd3b-4f92-9af6-30f88485ac41"
      content_id "f26e566e-2557-4921-b944-9373c32255f1"
      response_store :query_parameters

      radio :question1 do
        option :response1
        option :response2

        next_node do
          question :question2
        end
      end

      value_question :question2 do
        next_node do
          outcome :results
        end
      end

      outcome :results
    end
  end
end
