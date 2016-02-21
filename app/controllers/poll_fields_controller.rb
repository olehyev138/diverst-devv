class PollFieldsController < ApplicationController
  before_action :set_field, only: [:answer_popularities, :show]
  before_action :set_poll

  layout 'market_scope'

  def answer_popularities
    render json: @field.answer_popularities(entries: @poll.responses)
  end

  def show
    @responses = @poll.responses.includes(:user)
  end

  protected

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def set_field
    @field = Field.find(params[:id])
  end
end
