class PollsController < ApplicationController
  before_action :set_poll, only: [:edit, :update, :destroy, :show, :export_csv]

  layout 'market_scope'

  def index
    @polls = current_user.enterprise.polls
  end

  def new
    @poll = current_user.enterprise.polls.new
  end

  def create
    @poll = current_user.enterprise.polls.new(poll_params)

    if @poll.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    @responses = @poll.responses.order(created_at: :desc).page(params[:response_page]).per(5)
  end

  def update
    if @poll.update(poll_params)
      redirect_to @poll
    else
      render :edit
    end
  end

  def destroy
    @poll.destroy
    redirect_to action: :index
  end

  def export_csv
    send_data @poll.responses_csv, filename: "#{@poll.title}_responses.csv"
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
end
