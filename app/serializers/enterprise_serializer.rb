class EnterpriseSerializer < ActiveModel::Serializer
  attributes :id, :name, :theme

  def theme
    return nil if object.theme.nil?

    ThemeSerializer.new(object.theme).attributes
  end
end
