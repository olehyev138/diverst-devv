module NewsLinkHelper
  def news_link_picture(news_link)
    if news_link.author.present?
      image_tag news_link.author.avatar.expiring_url(3600, :thumb), width: '75%'
    else
      image_tag '/assets/missing_user.png', width: '75%'
    end
  end
end
