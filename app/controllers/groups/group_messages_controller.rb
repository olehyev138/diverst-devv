class Groups::GroupMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_message, only: [:show]

  layout 'erg'

  def index
    @messages = @group.messages.page(0)
  end

  def new
    @message = @group.messages.new
  end

  def create
    @message = @group.messages.new(message_params)

    if @message.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_message
    @message = @group.messages.find(params[:id])
  end

  def message_params
    params
      .require(:group_message)
      .permit(
        :subject,
        :content,
        segment_ids: []
      )
  end
end
