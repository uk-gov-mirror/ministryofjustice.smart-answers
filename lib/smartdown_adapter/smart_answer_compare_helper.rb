require 'gds_api/test_helpers/content_api'
require 'webmock'

module SmartdownAdapter
  class SmartAnswerCompareHelper
    include GdsApi::TestHelpers::ContentApi

    def initialize(question_name)
      @controller = SmartAnswersController.new
      @question_name = question_name
      stub_content_api_default_artefact
      @session = ActionDispatch::Integration::Session.new(Rails.application)
      stub_content_api_default_artefact
    end

    def get_smartanswer_content(started=false, responses=[])
      get_content(@question_name, false, started, responses)
    end

    def get_smartdown_content(started=false, responses=[])
      get_content(@question_name, true, started, responses)
    end

    def scenario_sequences
      scenario_folder_path = Rails.root.join('lib', 'smartdown_flows', @question_name, "scenarios", "*")
      scenario_strings = Dir[scenario_folder_path].map do |filename|
        get_file_as_string(filename).split("\n\n")
      end.flatten
      result = []
      scenario_strings.each do |scenario_string|
        responses = YAML::load(scenario_string+"\n").values.compact
        (0..responses.length).each do |i|
          result << responses[0..i]
        end
      end
      result.uniq!
      result
    end

  private

    def get_content(question_name, is_smartdown, started, responses)
      FLOW_REGISTRY_OPTIONS[:show_transitions] = is_smartdown
      url = "/#{question_name}"
      if started
        url += "/y"
      end
      unless responses.empty?
        url += "/"+responses.join("/")
      end
      @session.get url
      @session.response.body
    end

    def get_file_as_string(filename)
      data = ''
      f = File.open(filename, "r")
      f.each_line do |line|
        data += line
      end
      data
    end

    # Stub requests, and then dynamically generate a response based on the slug in the request
    def stub_content_api_default_artefact
      stub_request(:get, %r{\A#{CONTENT_API_ENDPOINT}/[a-z0-9-]+\.json}).to_return { |request|
        slug = request.uri.path.split('/').last.chomp('.json')
        {:body => artefact_for_slug(slug).to_json}
      }
    end

    def artefact_for_slug(slug)
      singular_response_base.merge(
          "title" => titleize_slug(slug),
          "format" => "guide",
          "id" => "#{CONTENT_API_ENDPOINT}/#{CGI.escape(slug)}.json",
          "web_url" => "http://frontend.test.gov.uk/#{slug}",
          "details" => {
              "need_id" => "1234",
              "business_proposition" => false, # To be removed and replaced with proposition tags
              "format" => "Guide",
              "alternative_title" => "",
              "overview" => "This is an overview",
              "video_summary" => "",
              "video_url" => "",
              "parts" => [
                  {
                      "id" => "overview",
                      "order" => 1,
                      "title" => "Overview",
                      "body" => "<p>Some content</p>"
                  },
                  {
                      "id" => "#{slug}-part-2",
                      "order" => 2,
                      "title" => "How to make a nomination",
                      "body" => "<p>Some more content</p>"
                  }
              ]
          },
          "tags" => [],
          "related" => []
      )
    end
  end
end
