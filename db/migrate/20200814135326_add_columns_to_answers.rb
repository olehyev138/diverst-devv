class AddColumnsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :benefits, :text
    add_column :answers, :duration, :integer, default: 0
    add_column :answers, :unit_of_duration, :string, default: ''
  end
end
