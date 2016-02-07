class CreateTopicFeedbacks < ActiveRecord::Migration
  def change
    create_table :topic_feedbacks do |t|
      t.belongs_to :topic
      t.text :content
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
