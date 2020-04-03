class Api::V1::ResourcesController < DiverstController
  include Api::V1::Concerns::Archivable

  before_action :set_policy, only: [:index, :create]

  private

  def set_policy
    @policy = if params[:group_id].present? || params[:initiative_id].present?
      GroupResourcePolicy
    else
      EnterpriseResourcePolicy
    end
  end

  def payload
    params
        .require(:resource)
        .permit(
            :id,
            :title,
            :folder_id,
            :url,
            :file,
            :resource_type,
            :group_id
          )
  end
end
