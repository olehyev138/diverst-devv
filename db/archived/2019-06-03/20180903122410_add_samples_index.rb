class AddSamplesIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :samples, :user_id
  end
end
