class User::EventsController < ApplicationController
  before_action :authenticate_user!, except: [:onboarding_calendar_data]
  after_action :visit_page, only: [:index]

  layout 'user'

  def index
    authorize Initiative
    @upcoming_events = current_user.initiatives.upcoming + current_user.invited_initiatives.upcoming
    @past_events =  current_user.initiatives.past + current_user.invited_initiatives.past
    @ongoing_events = current_user.initiatives.ongoing + current_user.invited_initiatives.ongoing
  end

  def calendar
    enterprise = current_user.enterprise
    @groups = enterprise.groups.all_parents
    @segments = enterprise.segments
    @q_form_submit_path = calendar_user_events_path
    @q = Initiative.ransack(params[:q])

    render 'shared/calendar/calendar_view'
  end

  # Return calendar data for onboarding screen
  # No current user, use token for authentication
  def onboarding_calendar_data
    user = User.find_by_invitation_token(params[:invitation_token], true)

    if user.present?
      @events = user.enterprise.initiatives.where('start >= ?', params[:start])
                                      .where('start <= ?', params[:end])

      render 'shared/calendar/events', format: :json
    else
      redirect_to user_root_path
    end
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'User\'s Events Page'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
