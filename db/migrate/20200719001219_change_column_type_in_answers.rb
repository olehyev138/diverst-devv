class ChangeColumnTypeInAnswers < ActiveRecord::Migration
  def change
    change_column :answers, :benefit_type, :string
  end
end
