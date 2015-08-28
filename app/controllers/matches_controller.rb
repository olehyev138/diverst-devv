class MatchesController < ApplicationController
  before_action :authenticate_admin!

  def test
    @match = Match.new
    @match.employee1 = current_admin.enterprise.employees.new
    @match.employee2 = current_admin.enterprise.employees.new
  end

  def score
    @match = Match.new
    @match.employee1 = current_admin.enterprise.employees.new
    @match.employee2 = current_admin.enterprise.employees.new
    @match.employee1.merge_info params[:match][:employee1_attributes]["custom-fields"].to_hash
    @match.employee2.merge_info params[:match][:employee2_attributes]["custom-fields"].to_hash

    render "test"
  end
end
