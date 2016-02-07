class FieldsController < ApplicationController
  before_action :authenticate_user!, only: [:join]
  before_action :set_field, only: [:edit, :update, :destroy, :show, :stats]
  skip_before_action :verify_authenticity_token, only: [:create]

  def stats
    render json: @field.elastic_stats
  end

  protected

  def set_field
    @field = current_user.enterprise.fields.find(params[:id])
  end

  def field_params
    params
      .require(:field)
      .permit(
        :name,
        :description,
        :logo,
        :send_invitations,
        member_ids: [],
        invitation_segment_ids: []
      )
  end
end
