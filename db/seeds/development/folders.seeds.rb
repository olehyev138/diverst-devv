def self.generate_views(enterprise, folder, no_views, is_enterprise_folder, group = nil)
  no_views.times do
    if is_enterprise_folder
      user = enterprise.users.where(enterprise: enterprise.id).sample
    else
      next if group.user_groups.empty?
      user = group.user_groups.where(accepted_member: true).sample.user

      folder.views.create!(user_id: user.id,
                           enterprise_id: enterprise.id,
                           folder_id: folder.id,
                           created_at: Faker::Time.between(folder.created_at + 1.minute, folder.created_at + 1.month)
      ) unless View.where(user_id: user.id, folder_id: folder.id).exists?
    end
  end
end

def self.generate_name(enterprise)
  enterprise.name == 'Diverst Inc' ? Faker::Space.unique.moon.capitalize : 'BAD ENTERPRISE ' + Faker::Lorem.unique.word.capitalize
end

after 'development:groups' do
  enterprise_folders_range = 5..7
  group_folders_range = 5..7
  views_range = 10..20

  nested_folder_chance = 7

  spinner = TTY::Spinner.new(":spinner Populating groups with folders...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      # Enterprise folders
      rand(enterprise_folders_range).times do
        folder = enterprise.folders.create!(
          name: generate_name(enterprise),
          created_at: Faker::Time.between(enterprise.created_at + 1.hour, Time.current - 2.days),
          group_id: nil)

        generate_views(enterprise, folder, rand(views_range), true)
      end

      # Group Folders
      enterprise.groups.each do |group|
        Faker::UniqueGenerator.clear # Clears used values for all generators

        rand(group_folders_range).times do
          folder = group.folders.create!(
            name: generate_name(enterprise),
            created_at: Faker::Time.between(group.created_at + 1.hour, Time.current - 2.days),
            enterprise_id: nil)

          generate_views(enterprise, folder, rand(views_range), false, group)

          # Have a small chance to have a nested folder
          if rand(100) < nested_folder_chance
            folder = group.folders.create!(
              name: generate_name(enterprise),
              parent_id: folder.id,
              created_at: Faker::Time.between(group.created_at + 1.hour, Time.current - 2.days),
              enterprise_id: nil)

            generate_views(enterprise, folder, rand(views_range), false, group)
          end
        end
      end
    end

    spinner.success("[DONE]")
  end
end
