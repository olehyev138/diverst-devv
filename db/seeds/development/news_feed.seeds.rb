after 'development:groups' do
  news_feed_posts_range = 2..5
  no_comments_range = 2..10
  no_likes_range = 5..10
  no_views_range = 20..30

  news_link_titles = [
    'China Behavior Rating System V/S Sweden Microchip implants | Must watch technology',
    'Roy Weathers discusses the impact tech and data are having on the workforce of the future in tax',
    'A New Hero Rises',
    'The Story of NASA\'s Black Female Scientists',
    'Work hard. Play Hard',
    'Invictus Games 2018',
    'Veteran\'s Day Parade'

  ]

  spinner = TTY::Spinner.new(":spinner Populating news feed with posts...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        rand(news_feed_posts_range).times do
          next if group.user_groups.empty?
          user = group.user_groups.where(accepted_member: true).sample.user

          group_message = GroupMessage.create!(group_id: group.id,
                                              subject: (enterprise.name == 'Diverst Inc' ? Faker::Lorem.sentence : 'BAD ENTERPRISE ' + Faker::Lorem.sentence),
                                              content: Faker::Lorem.paragraph,
                                              created_at: Faker::Time.between(1.year.ago, Time.current - 2.days),
                                              owner_id: user.id)

          news_link = NewsLink.create!(title: news_link_titles.sample,
                                      description: (enterprise.name == 'Diverst Inc' ? Faker::Lorem.sentence : 'BAD ENTERPRISE ' + Faker::Lorem.sentence),
                                      group_id: group.id,
                                      author_id: user.id,
                                      created_at: Faker::Time.between(1.year.ago, Time.current - 2.days),
                                      url: "http://www.google.com")

          social_link = SocialLink.create!(group_id: group.id,
                                          author_id: user.id,
                                          created_at: Faker::Time.between(1.year.ago, Time.current - 2.days),
                                          url: "https://twitter.com/CNN/status/942881446821355520",
                                          embed_code: '<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Former Director of National Intelligence James Clapper: Vladimir Putin &quot;knows how to handle an asset and that&#39;s what he&#39;s doing with the President&quot; <a href="https://t.co/KxXPcUNuSA">https://t.co/KxXPcUNuSA</a> <a href="https://t.co/CXYiFBCHam">pic.twitter.com/CXYiFBCHam</a></p>&mdash; CNN (@CNN) <a href="https://twitter.com/CNN/status/942881446821355520?ref_src=twsrc%5Etfw">December 18, 2017</a></blockquote>
		<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>')

          # Comments
          rand(no_comments_range).times do
            NewsLinkComment.create!(content: (enterprise.name == 'Diverst Inc' ? Faker::Lorem.paragraph : 'BAD ENTERPRISE ' + Faker::Lorem.paragraph),
                                   author_id: group.user_groups.where(accepted_member: true).sample.user.id,
                                   created_at: Faker::Time.between(news_link.created_at + 1.minute, news_link.created_at + 1.month),
                                   news_link_id: news_link.id)

            GroupMessageComment.create!(content: (enterprise.name == 'Diverst Inc' ? Faker::Lorem.paragraph : 'BAD ENTERPRISE ' + Faker::Lorem.paragraph),
                                       author_id: group.user_groups.where(accepted_member: true).sample.user.id,
                                       created_at: Faker::Time.between(group_message.created_at + 1.minute, group_message.created_at + 1.month),
                                       message_id: group_message.id)
          end

          # Likes
          rand(no_likes_range).times do
            user = group.user_groups.where(accepted_member: true).sample.user

            news_link.news_feed_link.likes
              .create!(user_id: user.id,
                      created_at: Faker::Time.between(news_link.created_at + 1.minute, news_link.created_at + 1.month),
                      enterprise_id: enterprise.id) unless Like.where(user_id: user.id, news_feed_link_id: news_link.news_feed_link.id).exists?

            group_message.news_feed_link.likes
              .create!(user_id: user.id,
                      created_at: Faker::Time.between(group_message.created_at + 1.minute, group_message.created_at + 1.month),
                      enterprise_id: enterprise.id) unless Like.where(user_id: user.id, news_feed_link_id: group_message.news_feed_link.id).exists?

            social_link.news_feed_link.likes
              .create!(user_id: user.id,
                      created_at: Faker::Time.between(social_link.created_at + 1.minute, social_link.created_at + 1.month),
                      enterprise_id: enterprise.id) unless Like.where(user_id: user.id, news_feed_link_id: social_link.news_feed_link.id).exists?

          end

          # Views
          rand(no_views_range).times do
            user = group.user_groups.where(accepted_member: true).sample.user

            news_link.news_feed_link.views
              .create!(user_id: user.id,
                      enterprise_id: enterprise.id,
                      created_at: Faker::Time.between(news_link.created_at + 1.minute, news_link.created_at + 1.month),
                      group_id: group.id) unless View.where(user_id: user.id, news_feed_link_id: news_link.news_feed_link.id).exists?

            group_message.news_feed_link.views
              .create!(user_id: user.id,
                      enterprise_id: enterprise.id,
                      created_at: Faker::Time.between(group_message.created_at + 1.minute, group_message.created_at + 1.month),
                      group_id: group.id) unless View.where(user_id: user.id, news_feed_link_id: group_message.news_feed_link.id).exists?

            social_link.news_feed_link.views
              .create!(user_id: user.id,
                      enterprise_id: enterprise.id,
                      created_at: Faker::Time.between(social_link.created_at + 1.minute, social_link.created_at + 1.month),
                      group_id: group.id) unless View.where(user_id: user.id, news_feed_link_id: social_link.news_feed_link.id).exists?
          end
        end
      end
    end
    spinner.success("[DONE]")
  end
end

