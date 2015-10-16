class Groups::NewsLinksController < ApplicationController
  before_action :authenticate_admin!, except: [:url_info]
  before_action :set_group, except: [:url_info]
  before_action :set_news_link, only: [:edit, :update, :destroy]

  layout "erg"

  def index
    @news_links = @group.news_links
  end

  def new
    @news_link = @group.news_links.new
  end

  def create
    @news_link = @group.news_links.new(news_link_params)

    if @news_link.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    if @news_link.update(news_link_params)
      redirect_to @news_link
    else
      render :edit
    end
  end

  def destroy
    @news_link.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = current_admin.enterprise.groups.find(params[:group_id])
  end

  def set_news_link
    @news_link = @group.news_links.find(params[:id])
  end

  def news_link_params
    params
    .require(:news_link)
    .permit(
      :url,
      :title,
      :description
      #segment_ids: []
    )
  end
end
