class AddHomeMessageToEnterprises < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.string :home_message, after: :banner_updated_at
    end
  end
end
