class PollsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :show, :edit]

  layout 'market_scope'

  def index
    authorize Poll
    @polls = policy_scope(Poll)
  end

  def new
    authorize Poll
    @poll = current_user.enterprise.polls.new
  end

  def create
    authorize Poll
    @poll = current_user.enterprise.polls.new(poll_params)
    @poll.owner = current_user

    if @poll.save
      track_activity(@poll, :create)
      flash[:notice] = 'Your survey was created'
      redirect_to action: :index
    else
      flash[:alert] = "#{@poll.errors.full_messages.first}"
      render :new
    end
  end

  def show
    authorize @poll

    @graphs = @poll.graphs.includes(:field, :aggregation)
    @responses = @poll.responses
      .includes(:user)
      .order(created_at: :desc)
  end

  def edit
    authorize @poll
  end

  def update
    authorize @poll
    if @poll.update(poll_params)
      track_activity(@poll, :update)
      flash[:notice] = 'Your survey was updated'
      redirect_to @poll
    else
      flash[:alert] = 'Your survey was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @poll

    track_activity(@poll, :destroy)
    @poll.destroy
    redirect_to action: :index
  end

  def export_csv
    authorize @poll, :show?
    PollDownloadJob.perform_later(current_user.id, @poll.id)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  protected

  def set_poll
    @poll = current_user.enterprise.polls.find(params[:id])
  end

  def poll_params
    params
      .require(:poll)
      .permit(
        :title,
        :description,
        :status,
        :initiative_id,
        group_ids: [],
        segment_ids: [],
        fields_attributes: [
          :id,
          :title,
          :_destroy,
          :gamification_value,
          :show_on_vcard,
          :saml_attribute,
          :type,
          :match_exclude,
          :match_weight,
          :match_polarity,
          :min,
          :max,
          :options_text,
          :alternative_layout
        ]
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Polls'
    when 'new'
      'Poll Creation'
    when 'show'
      "Poll: #{@poll.to_label}"
    when 'edit'
      "Poll Edit: #{@poll.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
