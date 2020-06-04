class PollResponsesController < ApplicationController
  include Rewardable

  before_action :authenticate_user!, only: [:new, :create, :thank_you]
  before_action :set_poll
  before_action :set_response, only: [:edit, :update, :destroy, :show]
  before_action :check_existence_of_survey_response, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :visit_page, only: [:index, :new]

  layout 'guest'

  # MISSING TEMPLATE
  def index
    @responses = @poll.responses
  end

  def new
    # Redirect to thank you page if user already answered
    if (response = current_user.poll_responses.where(poll: @poll).first)
      redirect_to action: 'thank_you', id: response.id
    end

    @response = @poll.responses.new
  end

  def create
    @response = @poll.responses.new(poll_response_params)
    @response.info.merge(fields: @response.poll.fields, form_data: params['custom-fields'])
    @response.user = current_user

    if @response.save
      user_rewarder('survey_response').add_points(@response)
      flash_reward "Now you have #{ current_user.credits } points"
      redirect_to action: :thank_you, poll_id: @poll.id, id: @response.id
    else
      render :new
    end
  end

  def update
    if @response.update(poll_response_params)
      redirect_to @poll
    else
      render :edit # edit template does not exist
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
    @poll = Poll.published.find(params[:poll_id])
  end

  def set_response
    @response = @poll.responses.find(params[:id])
  end

  def poll_response_params
    params.require(:poll_response).permit(:anonymous)
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Poll Response'
    when 'new'
      'Poll Response Creation'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end

  def check_existence_of_survey_response
    if @poll.responses.where(user_id: current_user.id).any?
      redirect_to user_root_path, alert: 'You have already submitted a response'
    end
  end
end
