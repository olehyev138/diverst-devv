class AddProgramToCustomTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_texts, :program, :text
  end
end
