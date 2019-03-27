class AddContributingGroupIdToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :contributing_group_id, :integer
    add_index 'answers', ['contributing_group_id'], name: 'index_answers_on_contributing_group_id'
  end
end
