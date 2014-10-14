namespace :usageanalysis do

  def path_for_flow_rb(flow_name)
    Pathname.new(Rails.root.join('lib', 'flows', "#{flow_name}.rb"))
  end

  def path_for_flow_yml(flow_name)
    Pathname.new(Rails.root.join('lib', 'flows', 'locales', 'en', "#{flow_yml_mapping(flow_name)}.yml"))
  end

  def strings_for_flow(flow_name)
    # benefits-abroad has no YML file
    return {} if flow_name == "benefits-abroad"
    YAML.load_file(path_for_flow_yml(flow_name))["en-GB"]["flow"][flow_name]
  end

  # Some flows don't use the same naming convention for the YML file. Sigh
  def flow_yml_mapping(flow_name)
    {
      "calculate-employee-redundancy-pay" => "calculate-redundancy-pay",
      "calculate-your-redundancy-pay" => "calculate-redundancy-pay"
    }.fetch(flow_name, flow_name)
  end

  def ignorable_commits
    [
      '72ff87a', # camille formating
      '3be1eb8', # camille formating
      '58f44da', # dheath refactor
      'c18ea93', # dheath refactor
      '4ccb785', # updated maslow need ids
      '0db1de5', # camille whitespace
      '9b83bdf', # dheath trailing rb whitespace
      'dcd9f0a', # camille tab changes
      '6ea79cf' # more maslow needs
    ]
  end

  def last_change_for_file(file)
    `git log -10 --follow --pretty=format:"%h %ad" --date=short #{file} | grep -v "#{ignorable_commits.join('\|')}" | head -1 | cut -d" " -f2`.strip
  end

  desc "list flows"
  task :list_flows => :environment do
    flow_registry = SmartAnswer::FlowRegistry.new(FLOW_REGISTRY_OPTIONS)

    headings = %w[slug, status, num_questions, num_outcomes, num_phrases, last_logic_update, last_content_update]
    results = [headings]

    flow_registry.flows.each do |flow|
      results << [
        flow.name,
        flow.status.to_s,
        flow.questions.length,
        flow.outcomes.length,
        strings_for_flow(flow.name).fetch("phrases", []).length,
        last_change_for_file(path_for_flow_rb(flow.name)),
        last_change_for_file(path_for_flow_yml(flow.name)),
      ] unless flow.name.ends_with?("-v2")
    end
    puts results.map { |r| r.join("\t") }.join("\n")
  end
end
