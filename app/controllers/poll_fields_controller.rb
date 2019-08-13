class PollFieldsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_field, only: [:answer_popularities, :show]
  before_action :set_poll
  after_action :visit_page, only: [:show]

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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'show'
      "Poll Field: #{@field.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
