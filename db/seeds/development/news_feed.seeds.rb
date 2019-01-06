after 'development:join_groups' do 
	puts 'populating news feed with posts...'
	Enterprise.all.each do |enterprise| 
		enterprise.groups.each do |group|
			if enterprise.name == "Diverst Inc"
				author = owner = group.user_groups.first.user
				news_feed = NewsFeed.create(group_id: group.id)

				group_message = GroupMessage.create(group_id: group.id,
				                    subject: Faker::Lorem.sentence, 
				                    content: Faker::Lorem.paragraph, 
				                    owner_id: owner.id)
				NewsFeedLink.create(approved: true,
									group_message_id: group_message.id,
									is_pinned: false, news_feed_id: news_feed.id)

				news_link = NewsLink.create(title: "China Behavior Rating System V/S Sweden Microchip implants | Must watch technology",
											description: Faker::Lorem.paragraph,
											group_id: group.id,
											author_id: author.id,
											url: "https://www.youtube.com/watch?v=3FMWcLZy3jU")
				NewsFeedLink.create(approved: true,
									news_link_id: news_link.id,
									is_pinned: false,
									news_feed_id: news_feed.id)

				social_link = SocialLink.create(group_id: group.id,
												author_id: author.id,
												url: "https://twitter.com/CNN/status/942881446821355520",
												embed_code: '<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Former Director of National Intelligence James Clapper: Vladimir Putin &quot;knows how to handle an asset and that&#39;s what he&#39;s doing with the President&quot; <a href="https://t.co/KxXPcUNuSA">https://t.co/KxXPcUNuSA</a> <a href="https://t.co/CXYiFBCHam">pic.twitter.com/CXYiFBCHam</a></p>&mdash; CNN (@CNN) <a href="https://twitter.com/CNN/status/942881446821355520?ref_src=twsrc%5Etfw">December 18, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>')
				NewsFeedLink.create(approved: true,
									social_link_id: social_link.id,
									is_pinned: false,
									news_feed_id: news_feed.id)
			end
		end
	end
	puts 'populating news feed with posts[DONE]'
end