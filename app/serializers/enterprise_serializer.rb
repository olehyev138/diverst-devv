class EnterpriseSerializer < ActiveModel::Serializer
  attributes :id, :name, :theme

  def theme
    return nil if object.theme.nil?
    return ThemeSerializer.new(object.theme).attributes
  end
end
