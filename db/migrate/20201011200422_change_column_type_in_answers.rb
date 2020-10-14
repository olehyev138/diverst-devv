class ChangeColumnTypeInAnswers < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    change_column :answers, :benefit_type, :string
  end
end
