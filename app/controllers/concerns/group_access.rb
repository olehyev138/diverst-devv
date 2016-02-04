module GroupAccess
  extend ActiveSupport::Concern

  def group_managers_only!
    return if view_context.can_manage_group?(@group)
    redirect_to @group
  end
end