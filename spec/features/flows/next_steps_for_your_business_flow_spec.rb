RSpec.feature "SmartAnswer::NextStepsForYourBusinessFlow" do
  let(:headings) do
    # <question name>: <text_for :title from erb>
    {
      flow_title: "Next steps for your business",
      crn: "What is your company registration number?",
      annual_turnover: "Will your business take more than £85,000 in a 12 month period?",
      employ_someone: "Do you want to employ someone?",
      business_intent: "Does your business do any of the following?",
      business_support: "Are you looking for financial support for:",
      business_premises: "Where are you running your business?",
      results: "Next steps for BUSINESS NAME LTD",
    }
  end

  let(:answers) do
    {
      crn: "123456789",
      annual_turnover: "Maybe in the future",
      employ_someone: "Maybe in the future",
      business_intent: "Sell goods online",
      business_support: "Growing your business",
      business_premises: "From home",
    }
  end

  before do
    stub_content_store_has_item("/next-steps-for-your-business")
    start(the_flow: headings[:flow_title], at: "next-steps-for-your-business")
    stub_request(:get, "https://api.companieshouse.gov.uk/company/123456789")
      .to_return(status: 200, body: { "company_name" => "BUSINESS NAME LTD" }.to_json)

    stub_request(:get, "https://api.companieshouse.gov.uk/company/987654321")
      .to_return(status: 404, body: { "errors" => [
        { "type" => "ch:service", "error" => "company-profile-not-found" },
      ] }.to_json)
  end

  around do |example|
    ENV["COMPANIES_HOUSE_API_KEY"] = "api-key"
    example.run
    ENV["COMPANIES_HOUSE_API_KEY"] = nil
  end

  scenario "Answers all questions" do
    answer(question: headings[:crn], of_type: :value, with: answers[:crn])
    answer(question: headings[:annual_turnover], of_type: :radio, with: answers[:annual_turnover])
    answer(question: headings[:employ_someone], of_type: :radio, with: answers[:employ_someone])
    answer(question: headings[:business_intent], of_type: :checkbox, with: answers[:business_intent])
    answer(question: headings[:business_support], of_type: :checkbox, with: answers[:business_support])
    answer(question: headings[:business_premises], of_type: :radio, with: answers[:business_premises])

    ensure_page_has(header: headings[:results])
  end

  scenario "Enters a invalid company registration number" do
    answer(question: headings[:crn], of_type: :value, with: "987654321")

    ensure_page_has(
      header: headings[:crn],
      text: "Company not found. Enter a valid company registration number.",
    )
  end
end
