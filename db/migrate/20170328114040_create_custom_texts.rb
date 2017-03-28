class CreateCustomTexts < ActiveRecord::Migration
  def change
    create_table :custom_texts do |t|
      t.text :erg
      t.references :enterprise, index: true, foreign_key: true
    end
  end
end
