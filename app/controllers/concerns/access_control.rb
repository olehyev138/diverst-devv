module AccessControl
  extend ActiveSupport::Concern

  def group_managers_only!
    return if view_context.can_manage_group?(@group)
    redirect_to @group
  end

  def resource_editors_only!(resource)
    return if view_context.can_edit_resource?(resource)
    redirect_to root_path
  end
end