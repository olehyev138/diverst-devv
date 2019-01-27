class MentoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mentoring, only: [:update, :destroy]

  def index
    @users = current_user.enterprise.users.enterprise_mentors([current_user.id] + current_user.mentors.ids) if params[:mentor]
    @users = current_user.enterprise.users.enterprise_mentees([current_user.id] + current_user.mentees.ids) if params[:mentee]
    
    if params.dig(:search, :value)
      search = params.dig(:search, :value)
      @users = @users.ransack({:mentoring_interests_name_cont => search, :first_name_cont => search, :last_name_cont => search, :email_cont => search, :m => "or"}).result(:distinct => true).includes(:mentoring_interests)
    end

    respond_to do |format|
      format.json { render json: MentoringDatatable.new(view_context, @users, current_user, params[:mentor].present? ? true: false) }
    end
  end

  def destroy
    @mentoring.destroy
    redirect_to :back
  end

  private

  def set_mentoring
    @mentoring = Mentoring.find_by_id(params[:id])
  end

  def search_params
      params.permit(:mentor, :mentee)
  end
end
