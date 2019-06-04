class AddOwnersToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.belongs_to :owner
    end

    change_table :group_messages do |t|
      t.belongs_to :owner
    end

    change_table :events do |t|
      t.belongs_to :owner
    end
  end
end
