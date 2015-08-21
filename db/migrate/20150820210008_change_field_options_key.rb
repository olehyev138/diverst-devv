class ChangeFieldOptionsKey < ActiveRecord::Migration
  def change
    rename_column(:field_options, :options_field_id, :field_id)
  end
end
