class Groups::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group
    before_action :set_link, :only => [:approve]
    
    layout 'erg'

    def index
        @posts = @group.news_feed_links.includes(:link).approved.order(created_at: :desc)
    end
    
    def pending
        @posts = @group.news_feed_links.includes(:link).not_approved.order(created_at: :desc)
    end
    
    def approve
        @link.approved = true
        if not @link.save
            flash[:alert] = "Link not approved"
        end
        redirect_to :back
    end

    protected

    def set_group
        @group = current_user.enterprise.groups.find(params[:group_id])
    end
    
    def set_link
        @link = @group.news_feed_links.find(params[:link_id])
    end
end
