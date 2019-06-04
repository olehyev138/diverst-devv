class CreateGroupsPolls < ActiveRecord::Migration[5.1]
  def change
    create_table :groups_polls do |t|
      t.belongs_to :group
      t.belongs_to :poll
    end
  end
end
