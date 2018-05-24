module PostsHelper
  def shared_message(post)
    "Post from #{post.link.group.name}" if post.shared?(@group)
  end
end
