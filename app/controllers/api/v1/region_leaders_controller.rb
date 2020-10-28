class Api::V1::RegionLeadersController < DiverstController
  before_action :polymorphize_leader_of_query, only: [:show, :index]
  before_action :polymorphize_leader_of_commit, only: [:create, :update]

  protected def klass
    GroupLeader
  end

  private

  def polymorphize_leader_of_commit
    params[:group_leader] = params[:region_leader]
    params.delete(:region_leader)
    polymorphize_leader_of_query(params[:group_leader])
  end

  def polymorphize_leader_of_query(temp_params = params)
    if temp_params[:region_id]
      temp_params[:leader_of_type] ||= 'Region'
      temp_params[:leader_of_id] ||= temp_params[:region_id]
      temp_params.delete(:region_id)
    end
  end
end
