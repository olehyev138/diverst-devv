class PollsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_poll, only: [:edit, :update, :destroy, :show]

  def index
    @polls = current_admin.enterprise.polls
  end

  def new
    @poll = current_admin.enterprise.polls.new
  end

  def create
    @poll = current_admin.enterprise.polls.new(poll_params)
    @poll.send_invitation_emails

    if @poll.save
      redirect_to action: :index
    else
      render :edit
    end
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

  protected

  def set_poll
    @poll = current_admin.enterprise.polls.find(params[:id])
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
