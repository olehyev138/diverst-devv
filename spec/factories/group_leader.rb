FactoryBot.define do
  factory :group_leader do
    user { create(:user) }
    leader_of { create(:group, enterprise: user.enterprise) }
    position_name { Faker::Company.profession }
    user_role { group.enterprise.user_roles.where(role_name: 'group_leader').first }
    trait :default_group_contact do
      default_group_contact false
    end

    after(:build) do |group_leader|
      UserGroup.create(user: group_leader.user, group: group_leader.group, accepted_member: true)
    end
  end

  factory :region_leader, class: GroupLeader do
    user { create(:user) }
    leader_of { create(:region, parent: create(:group, enterprise: user.enterprise)) }
    position_name { Faker::Company.profession }
    user_role { region.parent.enterprise.user_roles.where(role_name: 'group_leader').first }
    trait :default_group_contact do
      default_group_contact false
    end

    after(:build) do |group_leader|
      UserGroup.create(user: group_leader.user, group: group_leader.region.parent, accepted_member: true)
    end
  end
end
