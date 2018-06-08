class Groups::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group
    before_action :set_page,    :only => [:index, :pending]
    before_action :set_link,    :only => [:approve, :pin, :unpin]

    layout 'erg'

    def index
        if policy(@group).erg_leader_permissions?
                @count = base_query
                                .includes(:news_link, :group_message, :social_link)
                                .order(created_at: :desc)
                                .count

                @posts = base_query
                                .includes(:news_link, :group_message, :social_link)
                                .order(created_at: :desc)
                                .limit(@limit)
        else
            if @group.active_members.include? current_user
                @count = base_query
                            .includes(:news_link, :group_message, :social_link)
                            .joins(joins)
                            .where(where, current_user.segments.pluck(:id))
                            .order(is_pinned: :desc, created_at: :desc)
                            .count

                @posts = base_query
                            .includes(:news_link, :group_message, :social_link)
                            .joins(joins)
                            .where(where, current_user.segments.pluck(:id))
                            .order(is_pinned: :desc, created_at: :desc)
                            .limit(@limit)
            else
                @count = 0
                @posts = []
            end
        end
    end

    def pending
        @posts = @group.news_feed_links.includes(:news_link, :group_message, :social_link).not_approved.order(created_at: :desc)
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
        @group.news_feed_links.approved
    end
end
