module PostsHelper
  def shared?(post)
    post.news_feed.group.id != @group.id
  end

  def shared_message(post)
    "Post from #{post.news_feed.group.name}" if shared? post
  end
end
