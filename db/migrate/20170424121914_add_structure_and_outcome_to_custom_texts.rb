class AddStructureAndOutcomeToCustomTexts < ActiveRecord::Migration
  def change
    add_column :custom_texts, :structure, :text
    add_column :custom_texts, :outcome, :text
  end
end
