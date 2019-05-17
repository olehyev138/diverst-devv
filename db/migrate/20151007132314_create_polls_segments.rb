class CreatePollsSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :polls_segments do |t|
      t.belongs_to :poll
      t.belongs_to :segment
    end
  end
end
