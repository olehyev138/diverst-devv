class GroupsField < Field
  after_initialize :init

  include Optionnable

  def elasticsearch_field
    'combined_info.groups'
  end

  def format_value_name(value)
    Group.find(value).name
  rescue
    'Deleted ERG'
  end

  private

  def init
    self.title = 'ERGs'
    self.elasticsearch_only = true
  end
end
