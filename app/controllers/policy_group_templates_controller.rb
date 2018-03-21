class PolicyGroupTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy_group_template, only: [:edit, :update]

  layout 'global_settings'

  def index
    authorize PolicyGroupTemplate
    @policy_group_templates = current_user.enterprise.policy_group_templates
  end
  
  def edit
    authorize PolicyGroupTemplate
  end
  
  def update
    authorize PolicyGroupTemplate

    if @policy_group_template.update(policy_group_template_params)
      flash[:notice] = "Your policy group template was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your policy group template was not updated. Please fix the errors"
      render :edit
    end
  end

  protected

  def set_policy_group_template
    if current_user
      @policy_group_template = current_user.enterprise.policy_group_templates.find(params[:id])
    else
      user_not_authorized
    end
  end

  def policy_group_template_params
    params
      .require(:policy_group_template)
      .permit(
        :campaigns_index,
        :campaigns_create,
        :campaigns_manage,
        :events_index,
        :events_create,
        :events_manage,
        :polls_index,
        :polls_create,
        :polls_manage,
        :group_messages_index,
        :group_messages_create,
        :group_messages_manage,
        :groups_index,
        :groups_create,
        :groups_manage,
        :groups_members_manage,
        :groups_members_index,
        :metrics_dashboards_index,
        :metrics_dashboards_create,
        :news_links_index,
        :news_links_create,
        :news_links_manage,
        :enterprise_resources_index,
        :enterprise_resources_create,
        :enterprise_resources_manage,
        :segments_index,
        :segments_create,
        :segments_manage,
        :users_index,
        :users_manage,
        :initiatives_index,
        :initiatives_create,
        :initiatives_manage,
        :budget_approval,
        :logs_view,
        :groups_budgets_index,
        :groups_budgets_request,
        :groups_budgets_approve,
        :annual_budget_manage,
        :group_leader_manage,
        :sso_manage,
        :permissions_manage,
        :diversity_manage,
        :manage_posts,
        :branding_manage,
        :global_calendar
      )
  end
end
