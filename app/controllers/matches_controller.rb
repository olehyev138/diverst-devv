class MatchesController < ApplicationController
  before_action :authenticate_admin!

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
end
