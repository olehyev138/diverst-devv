class Groups::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :update?
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end
end
