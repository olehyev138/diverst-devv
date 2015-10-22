class PollFieldsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_field, only: [:answer_popularities]
  before_action :set_poll

  def answer_popularities
    render json: @field.answer_popularities(entries: @poll.responses)
  end

  protected

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def set_field
    @field = Field.find(params[:id])
  end
end
