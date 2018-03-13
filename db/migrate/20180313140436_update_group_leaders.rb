class UpdateGroupLeaders < ActiveRecord::Migration
  def change
    # update all group_leaders to have group_leader role and then
    # admins can set the roles accordingly
    GroupLeader.where(:role => nil).update_all(:role => "group_leader")
  end
end
