class Groups::GroupMessagesController < ApplicationController
    include Rewardable

    before_action :authenticate_user!
    before_action :set_group
    before_action :set_message, only: [:show, :destroy, :edit, :update]

    layout 'erg'

    def index
        @messages = @group.messages.includes(:owner).order(created_at: :desc).page(0)
    end

    def show
        @comments = @message.comments.includes(:author)

        @new_comment = GroupMessageComment.new

        @message.increment_view(current_user)
    end

    def new
        @message = @group.messages.new
        @message.build_news_feed_link
    end

    def edit
        authorize @message, :update?
        @message.build_news_feed_link
    end

    def create
        @message = @group.messages.new(message_params)
        @message.owner = current_user

        if @message.save
            user_rewarder("message_post").add_points(@message)
            flash_reward "Your message was created. Now you have #{current_user.credits} points"
            redirect_to group_posts_path(@group)
        else
            flash[:alert] = "Your message was not created. Please fix the errors"
            render :new
        end
    end

    def update
        authorize @message, :update?
        if @message.update(message_params)
            redirect_to group_posts_path(@group)
        else
            flash[:alert] = "Your message was not updated. Please fix the errors"
            render :edit
        end
    end

    def destroy
        user_rewarder("message_post").remove_points(@message)
        @message.destroy
        flash[:notice] = "Your message was removed. Now you have #{current_user.credits} points"

        redirect_to group_posts_path(@group)
    end

    def create_comment
        @message = @group.messages.find(params[:group_message_id])

        @comment = @message.comments.new(message_comments_params)
        @comment.author = current_user

        if @comment.save
            user_rewarder("message_comment").add_points(@comment)
            flash_reward "Your comment was created. Now you have #{current_user.credits} points"
        else
            flash[:alert] = "Comment not saved. Please fix errors"
        end

        redirect_to group_group_message_path(@group, @message)
    end

    protected

    def set_group
        current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
    end

    def set_message
        @message = @group.messages.find(params[:id])
    end

    def message_params
        params
            .require(:group_message)
            .permit(
                :subject,
                :content,
                segment_ids: [],
                news_feed_link_attributes: { shared_news_feed_ids: [] }
            )
    end

    def message_comments_params
        params
            .require(:group_message_comment)
            .permit(
                :content
            )
    end
end
