class SetDefaultAddToMemberListToFields < ActiveRecord::Migration[5.2]
  def change
    Field.all.each do |fld|
      fld.add_to_member_list ||= false
      fld.save
    end
  end
end
