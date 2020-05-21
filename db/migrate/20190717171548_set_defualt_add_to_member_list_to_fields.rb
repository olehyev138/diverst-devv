class SetDefualtAddToMemberListToFields < ActiveRecord::Migration
  def change
    Field.all.each do |fld|
      fld.add_to_member_list ||= false
      fld.save
    end
  end
end
