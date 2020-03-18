class AddAnswersCountToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :answers_count, :integer

    Question.find_each do |question|
      Question.reset_counters(question.id, :answers)
    end
  end
end
