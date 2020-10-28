class RegionLeadersController < DiverstController
  before_action :polymorphize_leader_of_query, only: [:show, :index]
  before_action :polymorphize_leader_of_commit, only: [:create, :update]

  private

  def polymorphize_leader_of_commit
    polymorphize_leader_of_query(params[:region_leader])
  end

  def polymorphize_leader_of_query(temp_params)
    if temp_params[:region_id]
      temp_params[:leader_of_type] ||= 'Region'
      temp_params[:leader_of_id] ||= temp_params[:region_id]
      temp_params.delete(:region_id)
    end
  end
end
