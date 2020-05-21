class ArchivedInitiativesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_initiative, only: [:restore, :destroy]
  after_action :visit_page, only: [:index]

  layout 'erg_manager'

  def index
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @initiatives = Initiative.archived_initiatives(current_user.enterprise).order(created_at: :desc)
  end

  def destroy
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy

    track_activity(@initiative, :destroy)
    @initiative.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def delete_all
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @initiatives = Initiative.archived_initiatives(current_user.enterprise).order(created_at: :desc)
    @initiatives.destroy_all

    respond_to do |format|
      format.html { redirect_to :back, notice: 'all archived events deleted' }
      format.js
    end
  end

  def restore_all
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @initiatives = Initiative.archived_initiatives(current_user.enterprise).order(created_at: :desc)
    @initiatives.update_all(archived_at: nil)

    respond_to do |format|
      format.html { redirect_to :back, notice: 'all archived events restored' }
      format.js
    end
  end

  def restore
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy

    @initiative.update(archived_at: nil)
    track_activity(@initiative, :restore)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

  def set_initiative
    @initiative = Initiative.find(params[:id])
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Archived Initiatives'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
