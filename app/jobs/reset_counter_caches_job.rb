class ResetCounterCachesJob < ActiveJob::Base
  queue_as :low

  def perform(*args)
    User.find_each do |user|
      User.reset_counters(user.id,
                          :initiatives,
                          :own_messages,
                          :social_links,
                          :own_news_links,
                          :answer_comments,
                          :message_comments,
                          :news_link_comments,
                          :mentors,
                          :mentees
                         )
    end

    Campaign.find_each do |campaign|
      Campaign.reset_counters(campaign.id, :questions)
    end

    Enterprise.find_each do |enterprise|
      Enterprise.reset_counters(enterprise.id,
                                :segments,
                                :polls,
                                :users,
                                :groups
                               )
    end

    Group.find_each do |group|
      Group.reset_counters(group.id, :views)
    end

    Budget.find_each do |budget|
      Budget.reset_counters(budget.id, :budget_items)
    end

    NewsFeedLink.find_each do |news_feed_link|
      NewsFeedLink.reset_counters(news_feed_link.id,
                                  :likes,
                                  :views
                                 )
    end

    Folder.find_each do |folder|
      Folder.reset_counters(folder.id, :views)
    end

    Poll.find_each do |poll|
      Poll.reset_counters(poll.id, :responses)
    end

    Answer.find_each do |answer|
      Answer.reset_counters(answer.id, :likes)
    end

    Resource.find_each do |resource|
      Resource.reset_counters(resource.id, :views)
    end

    Question.find_each do |question|
      Question.reset_counters(question.id, :answers)
    end
  end
end
