class Metrics::MentorshipGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index] # TODO: fix

  layout 'metrics'


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
