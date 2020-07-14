class ChangeDefaultStatusOfPollToDraft < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:polls, :status, from: 0, to: 1)
  end
end
