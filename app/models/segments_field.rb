class SegmentsField < Field
  after_initialize :init

  include Optionnable

  def elasticsearch_field
    'combined_info.segments'
  end

  def format_value_name(value)
    Segment.find(value).name
  end

  private

  def init
    self.title = 'Segments'
    self.elasticsearch_only = true
  end
end
