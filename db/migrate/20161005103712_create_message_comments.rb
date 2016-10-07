class CreateMessageComments < ActiveRecord::Migration
  def change
    create_table :group_message_comments do |t|
      t.text :content
      t.belongs_to :author
      t.belongs_to :message

      t.timestamps null: false
    end
  end
end
