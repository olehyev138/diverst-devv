module PostsHelper
  def shared?(post)
    post.group.id != @group.id
  end

  def shared_message(post)
    "Post from #{post.group.name}" if shared? post
  end
end
