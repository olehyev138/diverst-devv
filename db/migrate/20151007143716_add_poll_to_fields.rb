class AddPollToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.belongs_to :poll
    end
  end
end
