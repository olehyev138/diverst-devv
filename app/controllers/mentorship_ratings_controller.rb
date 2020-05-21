class MentorshipRatingsController < ApplicationController
  before_action :set_mentorship_rating, only: [:show]

  layout 'user'

  def new
    @mentorship_rating = current_user.mentorship_ratings.new(mentoring_session_id: params[:mentoring_session_id])
    render 'user/mentorship/ratings/new'
  end

  def show
    render 'user/mentorship/ratings/show'
  end

  def create
    @mentorship_rating = current_user.mentorship_ratings.new(mentorship_ratings_params)

    if @mentorship_rating.save
      redirect_to sessions_user_mentorship_index_path
    else
      flash[:alert] = 'Your feedback was not saved'
      render 'user/mentorship/ratings/new'
    end
  end

  private

  def mentorship_ratings_params
    params.require(:mentorship_rating).permit(
      :rating,
      :mentoring_session_id,
      :okrs_achieved,
      :valuable,
      :comments
    )
  end

  def set_mentorship_rating
    @mentorship_rating = current_user.mentorship_ratings.find(params[:id])
  end
end
