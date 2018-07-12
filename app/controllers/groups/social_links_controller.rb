class Groups::SocialLinksController < ApplicationController
    include Rewardable

    before_action :authenticate_user!
    before_action :set_group
    before_action :set_social_link, only: [:destroy]

    layout 'erg'

    def index
        @posts = @group.social_links.includes(:owner).order(created_at: :desc).page(0)
    end

    def new
        @social_link = @group.social_links.new
        @social_link.build_news_feed_link
    end

    def create
        @social_link = @group.social_links.new(social_link_params)
        @social_link.author = current_user

        # Set the original news feed ID
        @social_link.news_feed_link.news_feed_id = @group.news_feed.id
        @social_link.news_feed_link.save
        if @social_link.save
            user_rewarder("social_media_posts").add_points(@social_link)
            flash_reward "Your social_link was created. Now you have #{ current_user.credits } points"
            redirect_to group_posts_path(@group)
        else
            flash[:alert] = "Your social link was not created. Please fix the errors"
            redirect_to :back
        end
    end

    def destroy
      # If the post is deleted on the original group, delete it entirely
      if @group == @social_link.group
        user_rewarder("message_post").remove_points(@social_link)
        @social_link.destroy
      else
        @social_link.unlink(@group)
      end

      flash[:notice] = "Your social link was removed. Now you have #{current_user.credits} points"
      redirect_to group_posts_path(@group)
    end

    protected

    def set_group
        current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
    end

    def set_social_link
        @social_link = SocialLink.find(params[:id])
    end

    def social_link_params
        params
            .require(:social_link)
            .permit(
                :url,
                news_feed_link_attributes: [ news_feed_link_segment_ids: [], news_feed_ids: [] ]
            )
    end
end
