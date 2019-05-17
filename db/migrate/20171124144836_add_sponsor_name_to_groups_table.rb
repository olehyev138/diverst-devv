class AddSponsorNameToGroupsTable < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :sponsor_name, :string
  end
end
