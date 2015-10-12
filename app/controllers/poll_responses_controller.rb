class PollResponsesController < ApplicationController
  before_action :authenticate_admin!
  before_action :authenticate_employee!, only: [:new, :thank_you]
  before_action :set_poll
  before_action :set_response, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @responses = @poll.responses
  end

  def new
    # Redirect to thank you page if employee already answered
    if response = current_employee.poll_responses.where(poll: @poll).first
      redirect_to action: "thank_you", id: response.id
    end

    @response = @poll.responses.new
  end

  def create
    @response = @poll.responses.new
    @response.info.merge(fields: @response.poll.fields, form_data: params["custom-fields"])
    @response.employee = current_employee

    if @response.save
      redirect_to action: :thank_you, poll_id: @poll.id, id: @response.id
    else
      render :edit
    end
  end

  def update
    if @response.update(response_params)
      redirect_to @response
    else
      render :edit
    end
  end

  def destroy
    @response.destroy
    redirect_to action: :index
  end

  def thank_you
  end

  protected

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def set_response
    @response = @poll.responses.find(params[:id])
  end
end