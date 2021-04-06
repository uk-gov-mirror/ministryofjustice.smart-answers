require "smart_answer_flows/shared/redundancy_pay_flow"

module SmartAnswer
  class CalculateEmployeeRedundancyPayFlow < Flow
    def define
      content_id "a5b52037-1712-4544-a3d1-a352ce8a8287"
      name "calculate-employee-redundancy-pay"

      status :published
      satisfies_need "7b64d692-db45-428a-8767-131bb6d5b118"

      append(Shared::RedundancyPayFlow.build)
    end
  end
end
