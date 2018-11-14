class RevertGroupLeaders < ActiveRecord::Migration
  def change
    Enterprise.find_each do |enterprise|
      default_user_role_id = enterprise.default_user_role
      enterprise.users.joins(:user_role).where(:user_roles => {:role_type => "group"}).update_all(:user_role_id => default_user_role_id)
    end
  end
end
