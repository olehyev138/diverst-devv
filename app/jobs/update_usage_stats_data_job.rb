class UpdateUsageStatsDataJob < ActiveJob::Base
  queue_as :low

  def perform(*args)
    params = [
      [:social_links, :own_messages, :own_news_links], [nil],
      [:answer_comments, :message_comments, :news_link_comments], [nil],
      [:initiatives], ['initiatives.start < ? OR initiatives.id IS NULL', Time.now]
    ]

    params.each_slice(2) do |fields, where|
      Rails.cache.write(
        "count_list/#{User.model_name.name}:#{fields}:#{where}",
        User.count_list(*fields, where: where),
        expires_in: 2.hours)
    end

    Rails.cache.write('aggregate_login_count', User.all.map(&:sign_in_count), expires_in: 2.hours)
  end
end
