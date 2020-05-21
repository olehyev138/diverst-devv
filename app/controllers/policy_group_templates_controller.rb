class PolicyGroupTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy_group_template, only: [:edit, :update]
  after_action :visit_page, only: [:index, :edit]

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
      flash[:notice] = 'Your policy group template was updated'
      track_activity(@policy_group_template, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your policy group template was not updated. Please fix the errors'
      render :edit
    end
  end

  protected

  def set_policy_group_template
    @policy_group_template = current_user.enterprise.policy_group_templates.find(params[:id])
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
        :budget_approval,
        :group_leader_manage,
        :sso_manage,
        :permissions_manage,
        :diversity_manage,
        :manage_posts,
        :branding_manage,
        :global_calendar,
        :manage_all,
        :enterprise_manage,
        :groups_budgets_manage,
        :group_leader_index,
        :groups_insights_manage,
        :groups_layouts_manage,
        :group_resources_index,
        :group_resources_create,
        :group_resources_manage,
        :social_links_index,
        :social_links_create,
        :social_links_manage,
        :group_settings_manage,
        :group_posts_index,
        :mentorship_manage,
        :auto_archive_manage,
        :onboarding_consent_manage
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Policy Group Templates'
    when 'edit'
      "Policy Group Edit: #{@policy_group_template.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
