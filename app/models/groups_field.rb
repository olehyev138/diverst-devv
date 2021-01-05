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
    # To be verified : what exactly is the title property for? Is it displayed to the user on the frontend?
    self.title = 'ERGs'
    self.elasticsearch_only = true
  end
end
