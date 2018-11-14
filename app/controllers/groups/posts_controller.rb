class Groups::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group
    before_action :set_page,    :only => [:index, :pending]
    before_action :set_link,    :only => [:approve, :pin, :unpin]

    layout 'erg'

    def index
        if policy(@group).manage?
            without_segments
        else
            if GroupPostsPolicy.new(current_user, [@group]).view_latest_news?
                segment_ids = current_user.segment_ids
                
                if segment_ids.empty?
                  return without_segments
                end
                @count = NewsFeed.all_links(@group.news_feed.id, segment_ids, @group.enterprise).count

                @posts = NewsFeed.all_links(@group.news_feed.id, segment_ids, @group.enterprise)
                            .order(is_pinned: :desc, created_at: :desc)
                            .limit(@limit)
            else
                @count = 0
                @posts = []
            end
        end
    end

    def pending
        if @group.enterprise.enable_social_media?
          @posts = @group.news_feed_links.includes(:news_link, :group_message, :social_link).not_approved.order(created_at: :desc)
        else
          @posts = @group.news_feed_links.includes(:news_link, :group_message).not_approved.order(created_at: :desc)
        end
    end

    def approve
        @link.approved = true
        if not @link.save
            flash[:alert] = "Link not approved"
        end
        redirect_to :back
    end

    def pin
      @link.is_pinned = true
      if !@link.save
        flash[:alert] = "Link was not pinned"
      end
      redirect_to :back
    end

    def unpin
      @link.is_pinned = false
      if !@link.save
        flash[:alert] = "Link was not unpinned"
      end
      redirect_to :back
    end

    protected
    
    def without_segments
        @count = NewsFeed.all_links_without_segments(@group.news_feed.id, @group.enterprise).count
        @posts = NewsFeed.all_links_without_segments(@group.news_feed.id, @group.enterprise)
                        .order(is_pinned: :desc, created_at: :desc)
                        .limit(@limit)
    end
    
    def with_segments
    end

    def set_group
        @group = current_user.enterprise.groups.find(params[:group_id])
    end

    def set_page
        @limit = 5
        @page = params[:page].present? ? params[:page].to_i : 1
        @limit *= @page
    end

    def set_link
        @link = @group.news_feed_links.find(params[:link_id])
    end
end
