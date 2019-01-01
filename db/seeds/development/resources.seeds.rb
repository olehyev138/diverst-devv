after 'development:folders' do 
	urls = { "future of artificial intelligence" => "https://www.youtube.com/watch?v=-Xn6IDytVGw",
			 "bioengineering ethics" => "https://www.youtube.com/watch?v=k2NQ2SFuSN4",
			 "cultural diversity" => "https://www.youtube.com/watch?v=48RoRi0ddRU"  }
	Enterprise.all.each do |enterprise|
		enterprise.folders.each do|folder|
			title = urls.keys[rand(3)]
			FactoryGirl.create(:resource,
			                   folder_id: folder.id, 
			                   enterprise_id: enterprise.id, 
			                   title: title, 
			                   url: urls[title])
		end

		enterprise.groups.each do |group|
			group.folders.each do |folder|
				title = urls.keys[rand(3)]
				FactoryGirl.create(:resource, 
									folder_id: folder.id, 
									enterprise_id: nil, 
									group_id: group.id, 
									title: title, 
									url: urls[title])
			end
		end
	end
end