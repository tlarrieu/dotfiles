class JsonWithSharedContext < RSpec::Core::Formatters::JsonFormatter
  RSpec::Core::Formatters.register self, :message, :dump_summary, :dump_profile, :stop, :seed, :close

  private

  def format_example(example)
    shared = example.metadata[:shared_group_inclusion_backtrace]&.first
    _, file_path, line_number = shared&.inclusion_location&.match(/.\/(.*?):(\d+)/)&.to_a

    super.merge(included_from: { file_path: file_path, line_number: line_number }.compact)
  end
end
