class GroupsField < Field
  after_initialize :init

  include Optionnable

  def elasticsearch_field
    'group.name'
  end

  def format_value_name(value)
    Group.find(value).name
  rescue
    "Deleted #{self.enterprise ? self.enterprise.custom_text.erg : 'ERG'}"
  end

  private

  def init
    self.title = self.enterprise ? self.enterprise.custom_text.erg.pluralize : 'ERGs'
    self.elasticsearch_only = true
  end
end
