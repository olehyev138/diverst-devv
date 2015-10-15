class CreateGroupMessages < ActiveRecord::Migration
  def change
    create_table :group_messages do |t|
      t.belongs_to :group
      t.string :subject
      t.text :content

      t.timestamps null: false
    end
  end
end
