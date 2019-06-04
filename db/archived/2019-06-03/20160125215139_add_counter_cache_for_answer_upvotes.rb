class AddCounterCacheForAnswerUpvotes < ActiveRecord::Migration[5.1]
  def change
    change_table :answers do |t|
      t.integer :upvote_count, default: 0
    end
  end
end
