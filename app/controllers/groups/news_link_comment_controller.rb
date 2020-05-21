class Groups::NewsLinkCommentController < ApplicationController
  before_action :set_group, :set_news_link
  after_action :visit_page, only: [:edit]

  layout 'erg'

  def edit
    @comment = @news_link.comments.find(params[:id])
  end

  def update
    @comment = @news_link.comments.find(params[:id])

    if @comment.update(comment_params)
      flash[:notice] = 'Your comment was updated'
      redirect_to comments_group_news_link_url(id: @news_link, group_id: @group.id)
    else
      flash[:alert] = 'Your comment was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    @comment = @news_link.comments.find(params[:id])
    @comment.destroy
    redirect_to comments_group_news_link_url(id: @news_link, group_id: @group.id)
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_news_link
    @news_link = @group.news_links.find(params[:news_link_id])
  end

  def comment_params
    params
        .require(:news_link_comment)
        .permit(
          :content,
          :approved
        )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'edit'
      'News Link Comment Edit'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
