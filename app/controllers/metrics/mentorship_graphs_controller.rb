class Metrics::MentorshipGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    @data = {
      past_mentoring_sessions: '<todo>'
    }
  end

  def user_mentorship_interest_per_group
    respond_to do |format|
      format.json {
        render json: @graph.user_mentorship_interest_per_group
      }
      format.csv {
        GenericGraphsMentorshipDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_mentorship)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def mentoring_sessions_per_creator
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
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def mentoring_interests
    respond_to do |format|
      format.json {
        render json: @graph.mentoring_interests
      }
      format.csv {
        GenericGraphsMentoringInterestsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_interests)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end
end
