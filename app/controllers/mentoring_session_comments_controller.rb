class MentoringSessionCommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_mentoring_session

    def create
        @comment = @mentoring_session.comments.new(comment_params)
        @comment.user = current_user
        if @comment.save
            flash[:notice] = "Your comment was created."
        else
            flash[:alert] = "Your comment was not created. Please fix the errors"
        end

        redirect_to :back
    end

    protected

    def set_mentoring_session
        @mentoring_session = MentoringSession.find(params[:mentoring_session_id])
    end

    def comment_params
        params
            .require(:mentoring_session_comment)
            .permit(
                :content
            )
    end
