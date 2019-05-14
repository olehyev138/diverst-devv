class Metrics::MentorshipGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    @data = {
      mentoring_sessions: current_user.enterprise.mentoring_sessions.where('start <= ?', 1.month.ago).count,
      active_mentorships: Mentoring.active_mentorships(current_user.enterprise).count
    }
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
end
