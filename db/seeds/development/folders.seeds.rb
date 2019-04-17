after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating groups with folders...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      5.times {Folder.create(name: Faker::RickAndMorty.location, enterprise_id: enterprise.id, group_id: nil)}

      enterprise.groups.each do |group|
        5.times {Folder.create(name: Faker::RickAndMorty.location, group_id: group.id, enterprise_id: nil)}
      end

      # create nested folders
      Folder.create(name: Faker::RickAndMorty.location,
                    enterprise_id: enterprise.id,
                    parent_id: enterprise.folders.first.id,
                    group_id: nil)

      Folder.create(name: Faker::RickAndMorty.location,
                    enterprise_id: nil,
                    group_id: enterprise.groups.first.id,
                    parent_id: enterprise.groups.first.folders.first.id)
    end
    spinner.success("[DONE]")
  end
end