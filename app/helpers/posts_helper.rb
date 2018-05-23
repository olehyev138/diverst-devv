module PostsHelper
  def shared?(post)
    post.link.group.id != @group.id
  end

  def shared_message(post)
    "Post from #{post.link.group.name}" if shared? post
  end
end
