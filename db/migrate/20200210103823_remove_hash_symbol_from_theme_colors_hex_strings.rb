class RemoveHashSymbolFromThemeColorsHexStrings < ActiveRecord::Migration[5.2]
  def up
    Theme.find_each do |theme|
      next if theme.primary_color.blank?

      # If the first character of the hex string is # then remove it
      theme.primary_color = theme.primary_color[1..-1] if theme.primary_color[0] == '#'
      theme.secondary_color = theme.secondary_color[1..-1] if theme.secondary_color[0] == '#'

      theme.save!
    end
  end

  def down
    Theme.find_each do |theme|
      next if theme.primary_color.blank?

      # If the first character of the hex string is not # then add it
      theme.primary_color.insert(0, '#') if theme.primary_color[0] != '#'
      theme.secondary_color.insert(0, '#') if theme.secondary_color[0] != '#'

      theme.save!
    end
  end
end
