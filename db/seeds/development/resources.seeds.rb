after 'development:folders' do
  spinner = TTY::Spinner.new(":spinner Populating enterprise with folders...", format: :spin_2)
  spinner.run do |spinner|
    urls = {"future of artificial intelligence" => "https://www.youtube.com/watch?v=-Xn6IDytVGw",
            "bioengineering ethics" => "https://www.youtube.com/watch?v=k2NQ2SFuSN4",
            "cultural diversity" => "https://www.youtube.com/watch?v=48RoRi0ddRU"}
    Enterprise.all.each do |enterprise|
      enterprise.folders.each do |folder|
        title = urls.keys[rand(3)]
        Resource.create(folder_id: folder.id,
                        enterprise_id: enterprise.id,
                        title: title,
                        url: urls[title])
      end

      enterprise.groups.each do |group|
        group.folders.each do |folder|
          title = urls.keys[rand(3)]
          Resource.create(folder_id: folder.id,
                          enterprise_id: nil,
                          group_id: group.id,
                          title: title,
                          url: urls[title])
        end
      end
    end
    spinner.success("[DONE]")
  end
end