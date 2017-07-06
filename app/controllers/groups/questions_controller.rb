class Groups::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_user_group, only: [:survey, :submit_survey]
  after_action :verify_authorized, only: [:index]

  layout 'erg'

  def index
    authorize @group, :update?
  end

  def survey
  end

  def submit_survey

    if @user_group.present?
      #set flash message
      @user_group.info.merge(fields: @group.fields, form_data: params['custom-fields'])

      if @user_group.save
        flash[:notice] = "Your response was saved"
      else
        lash[:alert] = "Your response was not saved"
      end
    end

    redirect_to @group
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_user_group
    @user_group = UserGroup.where(group: @group).where(user: current_user).first
  end
end
