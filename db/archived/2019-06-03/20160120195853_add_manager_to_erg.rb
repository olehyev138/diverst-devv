class AddManagerToErg < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.belongs_to :manager
    end
  end
end
