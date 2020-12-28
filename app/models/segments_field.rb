class SegmentsField < Field
  after_initialize :init

  include Optionnable

  def elasticsearch_field
    'segment.name'
  end

  def format_value_name(value)
    Segment.find(value).name
  end

  private

  def init
    self.title = I18n.t('default_text_values.segments_fields.segments')
    self.elasticsearch_only = true
  end
end
