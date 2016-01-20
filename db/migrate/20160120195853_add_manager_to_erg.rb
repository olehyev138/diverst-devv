class AddManagerToErg < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.belongs_to :manager
    end
  end
end
