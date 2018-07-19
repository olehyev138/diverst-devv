class Groups::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group
    before_action :set_page,    :only => [:index, :pending]
    before_action :set_link,    :only => [:approve, :pin, :unpin]

    layout 'erg'

    def index
        if policy(@group).erg_leader_permissions?
                @count = base_query
                                .includes(:link)
                                .order(is_pinned: :desc, created_at: :desc)
                                .count

                @posts = base_query
                                .includes(:link)
                                .order(is_pinned: :desc, created_at: :desc)
                                .limit(@limit)
        else
            if @group.active_members.include? current_user
                @count = base_query_with_segments.count

                @posts = base_query_with_segments
                            .order(is_pinned: :desc, created_at: :desc)
                            .limit(@limit)
            else
                @count = 0
                @posts = []
            end
        end
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

    def where
        "news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)"
    end

    def joins
        "LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id"
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

    def base_query
        NewsFeedLink.combined_news_links(@group.news_feed.id)
    end
    
    def base_query_with_segments
        segment_ids = current_user.segments.ids
        if not segment_ids.empty?
            NewsFeedLink
                .combined_news_links_with_segments(@group.news_feed.id, current_user.segments.ids)
                .order(is_pinned: :desc, created_at: :desc)
                .limit(5)
        else
            return base_query
        end
    end
end
