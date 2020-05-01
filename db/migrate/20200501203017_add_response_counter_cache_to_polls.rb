class AddResponseCounterCacheToPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :responses_count, :integer

    Poll.column_reload!
    Poll.find_each do |folder|
      Poll.reset_counters(folder.id, :responses)
    end
  end
end
