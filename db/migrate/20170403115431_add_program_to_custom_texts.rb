class AddProgramToCustomTexts < ActiveRecord::Migration
  def change
    add_column :custom_texts, :program, :text
  end
end
