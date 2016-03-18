class Initiatives::FieldsController < ApplicationController
  before_action :set_group
  before_action :set_initiative
  before_action :set_field
  after_action :verify_authorized

  layout 'plan'

  def date_histogram
    authorize Initiative, :index?

    graph = DateHistogramGraph.new(
      index: current_user.enterprise.es_initiatives_index_name,
      field: "info.#{@field.id}.raw",
      interval: params[:interval] || 'month'
    )

    render json: graph.query_elasticsearch
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:initiative_id])
  end

  def set_field
    @field = @initiative.fields.find(params[:id])
  end

  def field_params
    params
      .require(:initiative_field)
      .permit(
        :description,
        :amount
      )
  end
end
