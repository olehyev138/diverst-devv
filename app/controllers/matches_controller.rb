class MatchesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_match, only: [:swipe, :show, :destroy]
  serialization_scope :current_employee

  def test
    @match = Match.new
    @match.user1 = current_admin.enterprise.employees.new
    @match.user2 = current_admin.enterprise.employees.new
  end

  def score
    @match = Match.new
    @match.user1 = current_admin.enterprise.employees.new
    @match.user2 = current_admin.enterprise.employees.new
    @match.user1.merge_info params[:match][:user1_attributes]["custom-fields"].to_hash
    @match.user2.merge_info params[:match][:user2_attributes]["custom-fields"].to_hash

    render "test"
  end

  def index
    render json: current_employee.top_matches(10)
  end

  def swipe
    render "Invalid swipe choice.", status: 400 if swipe_params[:choice] != Match.status[:accepted] && swipe_params[:choice] != Match.status[:rejected] # Only allow accepted or rejected statuses
    render "Already swiped.", status: 400 if @match.status_for(current_employee) != Match.status[:unswiped]

    @match.set_status(employee: current_employee, status: swipe_params[:choice])
    if @match.save
      render nothing: true, status: 200
    else
      render @match.errors
    end

    # Check if we have a match!
    if @match.both_accepted?
      HandleAcceptedMatchJob.perform_later @match
    end
  end

  def destroy
    return head :bad_request unless @match.both_accepted?

    if @match.update_attributes(archived: true)
      head :no_content
    else
      head :internal_server_error
    end
  end

  protected

  def swipe_params
    params.require(:swipe).permit(:choice)
  end

  def set_match
    @match = current_employee.matches.where(id: params[:id]).first
  end
end
