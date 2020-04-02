class RemoveHashSymbolFromThemeColorsHexStrings < ActiveRecord::Migration[5.2]
  def up
    Theme.column_reload!
    Theme.find_each do |theme|
      if theme.primary_color.present?
        # If the first character of the hex string is # then remove it
        theme.primary_color = theme.primary_color[1..-1] if theme.primary_color[0] == '#'
      end

      if theme.secondary_color.present?
        theme.secondary_color = theme.secondary_color[1..-1] if theme.secondary_color[0] == '#'
      end

      theme.save!
    end
  end

  def down
    Theme.column_reload!
    Theme.find_each do |theme|
      if theme.primary_color.blank?
        # If the first character of the hex string is not # then add it
        theme.primary_color.insert(0, '#') if theme.primary_color[0] != '#'
      end

      if theme.secondary_color.present?
        theme.secondary_color.insert(0, '#') if theme.secondary_color[0] != '#'
      end

      theme.save!
    end
  end
end
