class MatchesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!, except: [:test, :score], only: [:test, :score]
  before_action :set_match, only: [:swipe, :test, :score, :show]
  serialization_scope :current_user

  def test
    @match = Match.new
    @match.user1 = current_user.enterprise.users.new
    @match.user2 = current_user.enterprise.users.new
  end

  def score
    @match = Match.new
    @match.user1 = current_user.enterprise.users.new
    @match.user2 = current_user.enterprise.users.new
    @match.user1.merge_info params[:match][:user1_attributes]['custom-fields'].to_hash
    @match.user2.merge_info params[:match][:user2_attributes]['custom-fields'].to_hash

    render 'test'
  end

  def swipe
    return render json: { message: 'Invalid swipe choice.' }, status: 400 if swipe_params[:choice] != Match.status[:accepted] && swipe_params[:choice] != Match.status[:rejected] # Only allow accepted or rejected statuses
    return render json: { message: 'Already swiped.' }, status: 400 if @match.status_for(current_user) != Match.status[:unswiped]

    @match.set_status(user: current_user, status: swipe_params[:choice])

    if @match.save
      # Check if we have a match!
      HandleAcceptedMatchJob.perform_later @match if @match.both_accepted?

      render nothing: true, status: 200
    else
      render @match.errors
    end
  end

  def index
    render json: current_user.top_matches(10)
  end

  def show
    render json: @match
  end

  protected

  def swipe_params
    params.require(:swipe).permit(:choice)
  end

  def set_match
    @match = current_user.matches.where(id: params[:id]).first
  end
end
