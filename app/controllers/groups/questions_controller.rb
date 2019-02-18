class Groups::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_user_group, only: [:survey, :submit_survey]
  after_action :verify_authorized, only: [:index]

  layout 'erg'

  def index
    authorize @group, :insights?

    @answers_count = @group.user_groups.with_answered_survey.count
  end

  def survey
    unless @user_group.present?
      flash[:notice] = "Your have to join group before taking it's survey"
      redirect_to @group
    end
  end

  def submit_survey
    if @user_group.present?
      #set flash message
      @user_group.info.merge(fields: @group.survey_fields, form_data: params['custom-fields'])

      if @user_group.save
        flash[:notice] = "Your response was saved"
      else
        flash[:alert] = "Your response was not saved"
      end
    end

    redirect_to @group
  end

  def export_csv
    authorize @group, :insights?
    GroupQuestionsDownloadJob.perform_later(current_user.id, @group.id)
    flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
    redirect_to :back
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_user_group
    @user_group = UserGroup.where(group: @group).where(user: current_user).first
  end

  def csv_file_name
    "#{@group.name}-membership_preferances-#{Date.today}.csv"
  end
end
