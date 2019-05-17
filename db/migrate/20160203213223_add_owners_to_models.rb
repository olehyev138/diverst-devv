class AddOwnersToModels < ActiveRecord::Migration[5.1]
  def change
    change_table :campaigns do |t|
      t.belongs_to :owner
    end

    change_table :polls do |t|
      t.belongs_to :owner
    end

    change_table :resources do |t|
      t.belongs_to :owner
    end

    change_table :segments do |t|
      t.belongs_to :owner
    end
  end
end
