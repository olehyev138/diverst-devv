class AddLikesCountToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :likes_count, :integer

    Answer.find_each do |answer|
      Answer.reset_counters(answer.id, :likes)
    end
  end
end
