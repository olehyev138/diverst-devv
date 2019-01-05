after 'development:join_groups' do 
	Enterprise.all.each do |enterprise| 
		enterprise.groups.each do |group|
			if enterprise.name == "Diverst Inc"
				author = owner = group.user_groups.first.user
				FactoryGirl.create(:group_message, group_id: group.id, owner_id: owner.id)
				FactoryGirl.create(:news_link, group_id: group.id, author_id: author.id)
				FactoryGirl.create(:social_link, group_id: group.id, author_id: author.id)
			end
		end
	end
end