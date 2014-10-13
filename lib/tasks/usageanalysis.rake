namespace :usageanalysis do

  def path_for_flow_rb(flow_name)
    Pathname.new(Rails.root.join('lib', 'flows', "#{flow_name}.rb"))
  end

  def path_for_flow_yml(flow_name)
    Pathname.new(Rails.root.join('lib', 'flows', 'locales', 'en', "#{flow_yml_mapping(flow_name)}.yml"))
  end

  # Some flows don't use the same naming convention for the YML file. Sigh
  def flow_yml_mapping(flow_name)
    {
      "benefits-abroad" => "benefits-if-you-are-abroad",
      "calculate-employee-redundancy-pay" => "calculate-redundancy-pay",
      "calculate-your-redundancy-pay" => "calculate-redundancy-pay"
    }.fetch(flow_name, flow_name)
  end

  desc "list flows"
  task :list_flows => :environment do
    flow_registry = SmartAnswer::FlowRegistry.new(FLOW_REGISTRY_OPTIONS)

    headings = %w[slug, status, num_questions, num_outcomes, last_logic_update, last_content_update]
    results = [headings]

    flow_registry.flows.each do |flow|
      results << [
        flow.name,
        flow.status.to_s,
        flow.questions.length,
        flow.outcomes.length,
        `git log -1 --pretty=format:"%ad" --date=short #{path_for_flow_rb(flow.name)}`,
        `git log -1 --pretty=format:"%ad" --date=short #{path_for_flow_yml(flow.name)}`
      ] unless flow.name.ends_with?("-v2")
    end
    puts results.map { |r| r.join("\t") }.join("\n")
  end
end
