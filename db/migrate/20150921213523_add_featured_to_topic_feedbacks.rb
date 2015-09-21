class AddFeaturedToTopicFeedbacks < ActiveRecord::Migration
  def change
    change_table :topic_feedbacks do |t|
      t.boolean :featured
    end
  end
end
