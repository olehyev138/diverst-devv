def self.generate_views(enterprise, resource, no_views, is_enterprise_resource, group = nil)
  no_views.times do
    # get a random user to own the view
    if is_enterprise_resource
      user = enterprise.users.where(enterprise: enterprise.id).sample
    else
      next if group.user_groups.empty?
      user = group.user_groups.where(accepted_member: true).sample.user

      resource.views.create!(user_id: user.id,
                           enterprise_id: enterprise.id,
                           resource_id: resource.id,
                           created_at: Faker::Time.between(resource.created_at + 1.minute, resource.created_at + 1.month)
      ) unless View.where(user_id: user.id, resource_id: resource.id).exists?
    end
  end
end

after 'development:folders' do
  spinner = TTY::Spinner.new(":spinner Populating enterprises with folders...", format: :spin_2)
  spinner.run do |spinner|
    urls = {
      'future of artificial intelligence' => 'https://www.youtube.com/watch?v=-Xn6IDytVGw',
      'bioengineering ethics' => 'https://www.youtube.com/watch?v=k2NQ2SFuSN4',
      'cultural diversity' => 'https://www.youtube.com/watch?v=48RoRi0ddRU',
      'Learn to be an ERG manager' => 'https://www.google.com',
      'Black Career Women (BCW)' => 'https://www.google.com',
    }

    resources_range = 1..3
    views_range = 5..10

    Enterprise.all.each do |enterprise|
      # Enterprise resources
      enterprise.folders.each do |folder|
        rand(resources_range).times do
          title = urls.keys[rand(urls.count)]

          resource = Resource.create(folder_id: folder.id,
                                     enterprise_id: enterprise.id,
                                     title: title,
                                     created_at: Faker::Time.between(folder.created_at + 1.minute, Time.current - 2.days),
                                     url: urls[title])

          generate_views(enterprise, resource, rand(views_range), true)
        end
      end

      # Group resources
      enterprise.groups.each do |group|
        group.folders.each do |folder|
          rand(resources_range).times do
            title = urls.keys[rand(urls.count)]

            resource = Resource.create(folder_id: folder.id,
                            enterprise_id: nil,
                            group_id: group.id,
                            title: title,
                            created_at: Faker::Time.between(folder.created_at + 1.minute, Time.current - 2.days),
                            url: urls[title])

            generate_views(enterprise, resource, rand(views_range), false, group)
          end
        end
      end
    end
    spinner.success("[DONE]")
  end
end