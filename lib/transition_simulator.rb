require 'csv'

class TransitionSimulator
  def initialize(flow)
    @flow = flow
  end

  def self.simulate(flow)
    if raw_data = read_csv(flow)
      TransitionSimulator.new(flow).simulate(raw_data)
    else
      {}
    end
  end

  def self.read_csv(flow)
    filename = Rails.root.join("data", "#{flow.name}.csv")
    if File.exist?(filename)
      CSV.read(filename, headers:true).inject({}) do |memo, row|
        memo[row['URL']] = row['Count'].to_i
        memo
      end
    end
  end

  def simulate(data)
    transitions = {}
    data.each do |url, count|
      responses = url.split("/")[3..-1] || []
      next unless responses.any?
      end_state = @flow.process(responses)
      full_path = end_state.path + [end_state.current_node]
      full_path.each_cons(2).each do |from, to|
        transitions[[from, to]] ||= 0
        transitions[[from, to]] += count
      end
    end
    transitions
  end
end
