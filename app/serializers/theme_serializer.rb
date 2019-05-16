class ThemeSerializer < ActiveModel::Serializer
  attributes :id, :logo, :primary_color, :secondary_color, :logo_location
  
  def logo_location
    return nil if !object.logo?
    ENV["DOMAIN"] + object.logo.expiring_url(24.hours)
  end
end
