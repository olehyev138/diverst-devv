class PopulateUserAnswerCommentsCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :answer_comments)
    end
  end
end
