class PollResponsesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_poll
  before_action :set_response, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @responses = @poll.responses
  end

  def new
    @response = @poll.responses.new
  end

  def create
    @response = @poll.responses.new(response_params)

    if @response.save
      redirect_to action: :thank_you
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

  protected

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def set_response
    @response = @poll.responses.find(params[:id])
  end

  def response_params
    params
    .require(:response)
    .permit(
      :data,
      :description,
      member_ids: []
    )
  end
end
