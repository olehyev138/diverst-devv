class Metrics::MentorshipGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index] # TODO: fix

  layout 'metrics'

  def index
    @data = {
      past_mentoring_sessions: 12 # TODO
    }
  end

  def user_mentorship_interest_per_group
    respond_to do |format|
      format.json {
        render json: @graph.user_mentorship_interest_per_group
      }
    end
  end

  def mentoring_sessions_per_creator
    respond_to do |format|
      format.json {
        render json: @graph.mentoring_sessions_per_creator(mentorship_params[:date_range])
      }
    end
  end

  def mentoring_interests
    respond_to do |format|
      format.json {
        render json: @graph.mentoring_interests
      }
    end
  end


  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def mentorship_params
    params.permit(
      date_range: [
        :from_date,
        :to_date
      ],
      scoped_by_models: []
    )
  end
end
