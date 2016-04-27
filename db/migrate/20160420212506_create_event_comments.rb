class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.belongs_to :event
      t.belongs_to :user

      t.text :content
    end
  end
end
