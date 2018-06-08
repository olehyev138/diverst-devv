class Groups::NewsLinksController < ApplicationController
    include Rewardable

    before_action :authenticate_user!

    before_action :set_group, except: [:url_info]
    before_action :set_news_link, only: [:comments, :create_comment, :edit, :update, :destroy, :news_link_photos]

    layout 'erg'

    def index
        @news_links = @group.news_links.includes(:author).order(created_at: :desc)
    end

    def new
        @news_link = @group.news_links.new
    end

    def edit; end

    def comments
        @comments = @news_link.comments.includes(:author)
        @new_comment = NewsLinkComment.new
        @news_link.increment_view(current_user)
    end

    def create_comment
        @comment = @news_link.comments.new(news_link_comment_params)
        @comment.author = current_user

        if @comment.save
            user_rewarder("news_comment").add_points(@comment)
            flash_reward "Your comment was created. Now you have #{current_user.credits} points"
        else
            flash[:alert] = "Your comment was not created. Please fix the errors"
        end

        redirect_to action: :comments
    end

    def create
        @news_link = @group.news_links.new(news_link_params)
        @news_link.author = current_user

        if @news_link.save
            user_rewarder("news_post").add_points(@news_link)
            flash_reward "Your news was created. Now you have #{current_user.credits} points"
            redirect_to group_posts_path(@group)
        else
            flash[:alert] = "Your news was not created. Please fix the errors"
            render :edit
        end
    end

    def update
        if @news_link.update(news_link_params)
            flash[:notice] = "Your news was updated"
            redirect_to group_posts_path(@group)
        else
            flash[:alert] = "Your news was not updated. Please fix the errors"
            render :edit
        end
    end

    def destroy
        user_rewarder("news_post").remove_points(@news_link)
        @news_link.destroy
        flash[:notice] = "Your news was removed. Now you have #{current_user.credits} points"
        redirect_to group_posts_path(@group)
    end

    # this is not a route found in config/routes.rb
    # Gets basic information about a web article (title and lede) from its url
    def url_info
        page = Pismo::Document.new(params[:url])

        render json: {
                   title: page.title,
                   description: page.lede
               }
    end

    def news_link_photos
        @resize = true
        @photos = @news_link.photos
    end

    protected

    def set_group
        current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
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
                :description,
                :picture,
                :photos_attributes => [:file, :_destroy, :id],
                :segment_ids => []
            )
    end

    def news_link_comment_params
        params
            .require(:news_link_comment)
            .permit(
                :content
            )
    end
end
