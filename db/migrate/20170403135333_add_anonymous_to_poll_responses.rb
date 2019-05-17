class AddAnonymousToPollResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :poll_responses, :anonymous, :boolean, default: false
  end
end
