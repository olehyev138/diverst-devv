class ConversationsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_conversation, only: [:destroy]
  serialization_scope :current_employee

  def index
    render json: current_employee.matches.not_archived.accepted
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

  def set_conversation
    @match = current_employee.matches.where(id: params[:id]).first
  end
end
