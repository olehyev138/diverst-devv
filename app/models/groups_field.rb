class GroupsField < Field
  after_initialize :init

  include Optionnable

  def elasticsearch_field
    'group.name'
  end

  def format_value_name(value)
    Group.find(value).name
  rescue
    I18n.t('errors.group.deleted')
  end

  private

  def init
    self.title = 'ERGs'
    self.elasticsearch_only = true
  end
end
