class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :author
      t.belongs_to :recipient

      t.text :content

      t.timestamps null: false
    end
  end
end
