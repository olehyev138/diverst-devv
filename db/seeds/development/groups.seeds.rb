after 'development:users' do
  enterprise = Enterprise.last
  nb_groups = ENV["NB_GROUPS"] || 10
  groups_to_create = []

  nb_groups.times do |i|
    g = enterprise.groups.create(
      name: Faker::Lorem.word.capitalize,
      description: Faker::Lorem.sentence
    )

    enterprise.users.each do |user|
      g.members << user if rand(100) < 25
    end
  end
  
  groups_to_create << enterprise.groups.create(
    name: "The Mentor Network",
    description: "The Mentor Network is designed to assist associates with their ongoing career development through engagement with a mentor or mentee. The goal is to create a community in which mentors and mentees can learn from one another to foster career enrichment and advancement.",
    default_mentor_group: true
  )

  Group.import groups_to_create
end
