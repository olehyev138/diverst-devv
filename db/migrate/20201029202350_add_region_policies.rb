OLD_DEFAULT = [
    ["Admin", 0],
    ["Diversity Manager", 1],
    ["National Manager", 2],
    ["Group Leader", 3],
    ["Group Treasurer", 4],
    ["Group Content Creator", 5],
    ["User", 6],
]

NEW_DEFAULT = [
    ["Admin", 0],
    ["Diversity Manager", 1],
    ["National Manager", 2],
    ["Region Leader", 3],
    ["Region Treasurer", 4],
    ["Region Content Creator", 5],
    ["Group Leader", 6],
    ["Group Treasurer", 7],
    ["Group Content Creator", 8],
    ["User", 9],
]

class AddRegionPolicies < ActiveRecord::Migration[5.2]
  def up
    Enterprise.find_each do |ent|
      current_roles = ent.user_roles.order(priority: :asc).pluck(:role_name, :priority)
      if current_roles == OLD_DEFAULT
        ent.user_roles.find_by(role_name: 'User').update(priority: 9)
        ent.user_roles.find_by(role_name: 'Group Content Creator').update(priority: 8)
        ent.user_roles.find_by(role_name: 'Group Treasurer').update(priority: 7)
        ent.user_roles.find_by(role_name: 'Group Leader').update(priority: 6)
        ent.user_roles.create([
                                  {:role_name => "Region Leader", :role_type => "group", :priority => 3},
                                  {:role_name => "Region Treasurer", :role_type => "group", :priority => 4},
                                  {:role_name => "Region Content Creator", :role_type => "group", :priority => 5},
                              ])
      end
    end
  end

  def down
    Enterprise.find_each do |ent|
      current_roles = ent.user_roles.order(priority: :asc).pluck(:role_name, :priority)
      if current_roles == NEW_DEFAULT
        ent.user_roles.where('`user_roles`.`role_name` LIKE "%Region%"').destroy_all
        ent.user_roles.find_by(role_name: 'Group Leader').update(priority: 3)
        ent.user_roles.find_by(role_name: 'Group Treasurer').update(priority: 4)
        ent.user_roles.find_by(role_name: 'Group Content Creator').update(priority: 5)
        ent.user_roles.find_by(role_name: 'User').update(priority: 6)
      end
    end
  end
end
