class AddSamplesIndex < ActiveRecord::Migration
  def change
    add_index :samples, :user_id
  end
end
