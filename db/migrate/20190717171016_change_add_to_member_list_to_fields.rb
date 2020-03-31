class ChangeAddToMemberListToFields < ActiveRecord::Migration[5.2]
  def change
    change_column :fields, :add_to_member_list, :boolean, default: false
  end
end
