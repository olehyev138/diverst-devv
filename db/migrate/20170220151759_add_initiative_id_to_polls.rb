class AddInitiativeIdToPolls < ActiveRecord::Migration
  def change
    add_reference :polls, :initiative, index: true, foreign_key: true
  end
end
