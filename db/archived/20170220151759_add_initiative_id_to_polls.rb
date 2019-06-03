class AddInitiativeIdToPolls < ActiveRecord::Migration[5.1]
  def change
    add_reference :polls, :initiative, index: true, foreign_key: true
  end
end
