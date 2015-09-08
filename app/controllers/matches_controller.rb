class MatchesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_match, only: [:swipe, :show]
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
    render nothing: true, status: 400 if swipe_params[:choice] != Match.status[:accepted] && swipe_params[:choice] != Match.status[:denied]
    @match.set_status(employee: current_employee, status: swipe_params[:choice])
    if @match.save
      render nothing: true, status: 200
    else
      render @match.errors
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
