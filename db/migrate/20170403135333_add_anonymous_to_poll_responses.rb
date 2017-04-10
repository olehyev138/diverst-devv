class AddAnonymousToPollResponses < ActiveRecord::Migration
  def change
    add_column :poll_responses, :anonymous, :boolean, default: false
  end
end
