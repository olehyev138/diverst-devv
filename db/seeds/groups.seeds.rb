after :users do
  enterprise = Enterprise.last
  nb_groups = ENV["NB_GROUPS"] || 10
  groups_to_create = []

  nb_groups.times do |i|
    g = enterprise.groups.new(
      name: Faker::Commerce.color.capitalize,
      description: Faker::Lorem.sentence
    )

    enterprise.users.each do |user|
      g.members << user if rand(100) < 25
    end

    groups_to_create << g
  end

  Group.import groups_to_create
end