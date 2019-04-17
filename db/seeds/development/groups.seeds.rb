def self.populate_group(enterprise, group)
  group_members = []
  enterprise.users.each do |user|
    # calling create fails with 'default_mentor_group not a method' for some unknown reason
    # using import for user groups is probably better anyway
    group_members << UserGroup.new(group_id: group.id, user_id: user.id,
                                   accepted_member: true,
                                   created_at: Faker::Time.between(2.years.ago, Time.current - 2.days)) if rand(100) < 25
  end

  UserGroup.import group_members
end


after 'development:users' do
  no_groups = 10
  max_subgroups = 5

  group_names = [
    'Black Professional Network',
    'Asian Blue Community',
    'Global Network',
    'Latina Cultural Network',
    'Pride Network',
    'Women\'s Network',
    'Ability Network',
    'Veterans Network',
    'African Affinity',
    'Asia Link Network',
    'Pan Asian Community',
    'Parent Network',
    'Professional Employee Network',
    'Disability Caregivers Network'
  ]

  spinner = TTY::Spinner.new(":spinner Populating enterprise with groups...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      # shuffle group_names & take first 10
      group_names.shuffle.slice(0..no_groups).each do |group_name|
        group_name = 'BAD ENTERPRISE ' + group_name if enterprise.name != 'Diverst Inc'
        group = enterprise.groups.create(name: group_name, description: "",
                                         created_at: Faker::Time.between(2.years.ago, Time.current - 2.days))

        # create subgroups
        (0..rand(0..max_subgroups)).each do |i|
          subgroup_prefix = group.name.split(' ').reduce('') { |prefix, word| prefix + word[0] }
          subgroup_name = subgroup_prefix + ' Chapter ' + (65 + i).chr
          subgroup_name = 'BAD ENTERPRISE ' + subgroup_name if enterprise.name != 'Diverst Inc'

          subgroup = group.children.create(name: subgroup_name, description: "",
                                            created_at: Faker::Time.between(2.years.ago, Time.current - 2.days))

          self.populate_group(enterprise, subgroup)
        end

        self.populate_group(enterprise, group)
      end

      # always create mentor network group
      mentor_group_name = enterprise.name == 'Diverst Inc' ? 'The Mentor Network' : 'BAD ENTERPRISE The Mentor Network'
      mentor_group = enterprise.groups.create(
        name: mentor_group_name,
        description: "The Mentor Network is designed to assist associates with their ongoing career development through engagement with a mentor or mentee. The goal is to create a community in which mentors and mentees can learn from one another to foster career enrichment and advancement.",
        default_mentor_group: true
      )

      self.populate_group(enterprise, mentor_group)
    end
    spinner.success("[DONE]")
  end
end
