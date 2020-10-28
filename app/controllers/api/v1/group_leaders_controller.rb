class Api::V1::GroupLeadersController < DiverstController
  before_action :polymorphize_leader_of_query, only: [:show, :index]
  before_action :polymorphize_leader_of_commit, only: [:create, :update]

  private

  def polymorphize_leader_of_commit
    polymorphize_leader_of_query(params[:group_leader])
  end

  def polymorphize_leader_of_query(temp_params = params)
    if temp_params[:group_id]
      temp_params[:leader_of_type] ||= 'Group'
      temp_params[:leader_of_id] ||= temp_params[:group_id]
      temp_params.delete(:group_id)
    end
  end
end
