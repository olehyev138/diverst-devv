class AddSponsorNameToGroupsTable < ActiveRecord::Migration
  def change
    add_column :groups, :sponsor_name, :string
  end
end
