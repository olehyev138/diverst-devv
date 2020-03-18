class AddAddToMemberListToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :add_to_member_list, :boolean
  end
end
