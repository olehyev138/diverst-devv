class AddTitleToAnswers < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :answers, :title
      add_column :answers, :title, :string
    end
  end
end
