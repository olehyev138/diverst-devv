class AddPollToFields < ActiveRecord::Migration[5.1]
  def change
    change_table :fields do |t|
      t.belongs_to :poll
    end
  end
end
