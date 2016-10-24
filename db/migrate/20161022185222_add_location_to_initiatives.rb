class AddLocationToInitiatives < ActiveRecord::Migration
  def change
    change_table :initiatives do |t|
      t.string :location
    end
  end
end
