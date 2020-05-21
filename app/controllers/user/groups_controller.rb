class User::GroupsController < ApplicationController
  before_action :authenticate_user!
  after_action :visit_page, only: [:index]

  layout 'user'

  def index
    @groups = current_user.enterprise.groups.order(:position).all_parents
  end

  def join
    @group = current_user.enterprise.groups.find(params[:id])
    return if policy(@group).is_a_member?

    UserGroup.create!(user_id: current_user.id, group_id: @group.id, accepted_member: @group.pending_users.disabled?)

    @group.save
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{c_t(:erg)} List"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
