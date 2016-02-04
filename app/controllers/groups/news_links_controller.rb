class Groups::NewsLinksController < ApplicationController
  include AccessControl

  before_action :authenticate_user!
  before_action :set_group, except: [:url_info]
  before_action :group_managers_only!, except: [:index]
  before_action :set_news_link, only: [:edit, :update, :destroy]

  layout 'erg'

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
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @news_link.destroy
    redirect_to action: :index
  end

  # Gets basic information about a web article (title and lede) from its url
  def url_info
    page = Pismo::Document.new(params[:url])

    render json: {
      title: page.title,
      description: page.lede
    }
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
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
      )
  end
end
