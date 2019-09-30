class UpdateUsageStatsDataJob < ActiveJob::Base
  queue_as :low

  def perform(*args)
    params = [
      [:social_links, :own_messages, :own_news_links], [nil],
      [:answer_comments, :message_comments, :news_link_comments], [nil],
      [:initiatives], ['initiatives.start < ? OR initiatives.id IS NULL', Time.now]
    ]

    Enterprise.find_each do |ent|
      params.each_slice(2) do |fields, where|
        Rails.cache.write(
          "count_list/#{User.model_name.name}:#{fields}:#{where}",
          User.count_list(*fields, where: where, enterprise_id: ent.id))
      end

      Rails.cache.write(
        "aggregate_login_count:#{ent.id}",
        ent.users.all.map do |usr|
          [usr.id, usr.sign_in_count]
        end
      )

      Rails.cache.write("total_page_visitations:#{ent.id}", ent.total_page_visitations)
    end
  end
end
