class CreatePollResponses < ActiveRecord::Migration
  def change
    create_table :poll_responses do |t|
      t.belongs_to :poll
      t.belongs_to :employee
      t.text :data

      t.timestamps null: false
    end
  end
end
