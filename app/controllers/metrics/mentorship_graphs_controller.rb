class Metrics::MentorshipGraphsController < ApplicationController
  include Metrics

  after_action :visit_page, only: [:index]

  layout 'metrics'

  def index
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?
    @data = {
      mentoring_sessions: current_user.enterprise.mentoring_sessions.where('start <= ?', 1.month.ago).count,
      active_mentorships: Mentoring.active_mentorships(current_user.enterprise).count,
      total_mentors: current_user.enterprise.users.joins('JOIN mentorings ON users.id = mentorings.mentor_id').select(:id).distinct.count(:id),
      total_mentees: current_user.enterprise.users.joins('JOIN mentorings ON users.id = mentorings.mentee_id').select(:id).distinct.count(:id)
    }
  end

  def user_mentorship
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { }
      format.csv {
        UserMentorsCsvJob.perform_later(current_user.id, @user.id)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def users_mentorship
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?
    respond_to do |format|
      format.csv {
        csv_version = (params[:version] || 1).to_i
        AllUsersMentorsCsvJob.perform_later(current_user.id, version: csv_version)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def user_mentors
    authorize MetricsDashboard, :index?
    user_id = params[:user_id].to_i
    user = User.find(user_id)
    type = params[:type] || 'mentees'
    respond_to do |format|
      format.json {
        render json: UserMentorGenericListDatatable.new(view_context, user_id, user.send(type))
      }
    end
  end

  def users_mentorship_count
    authorize MetricsDashboard, :index?
    type = params[:type] || 'has_either'
    respond_to do |format|
      format.json {
        render json: UserMentorshipStatsDatatable.new(view_context, type: type)
      }
    end
  end

  def top_mentors
    authorize MetricsDashboard, :index?

    number = params[:number].to_i
    type = params[:type] || 'mentor'
    other = type == 'mentor' ? 'mentee' : 'mentor'

    respond_to do |format|
      format.json {
        render json: @graph.top_mentors(type, other, number)
      }
      format.csv {
        # TODO
        render json: { notice: 'TODO' }
      }
    end
  end

  def mentors_per_group
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.mentors_per_group('mentor')
      }
      format.csv {
        # TODO Later
        render json: { notice: 'TODO' }
      }
    end
  end

  def user_mentorship_interest_per_group
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    respond_to do |format|
      format.json {
        render json: @graph.user_mentorship_interest_per_group
      }
      format.csv {
        GenericGraphsMentorshipDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_mentorship)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def mentoring_sessions_per_creator
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    respond_to do |format|
      format.json {
        render json: @graph.mentoring_sessions_per_creator(metrics_params[:date_range])
      }
      format.csv {
        GenericGraphsMentoringSessionsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          @from_date,
          @to_date
        )
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_sessions)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def mentoring_interests
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    respond_to do |format|
      format.json {
        render json: @graph.mentoring_interests
      }
      format.csv {
        GenericGraphsMentoringInterestsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_interests)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Mentorship Metrics'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
