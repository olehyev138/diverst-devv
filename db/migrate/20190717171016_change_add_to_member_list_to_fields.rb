class ChangeAddToMemberListToFields < ActiveRecord::Migration
  def change
    change_column :fields, :add_to_member_list, :boolean, default: false
  end
end
