class AddAddToMemberListToFields < ActiveRecord::Migration
  def change
    add_column :fields, :add_to_member_list, :boolean
  end
end
