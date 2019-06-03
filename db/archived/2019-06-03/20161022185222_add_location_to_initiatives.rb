class AddLocationToInitiatives < ActiveRecord::Migration[5.1]
  def change
    change_table :initiatives do |t|
      t.string :location
    end
  end
end
