class GroupFolderPolicy < GroupBasePolicy
  def base_index_permission
    'group_resources_index'
  end

  def base_create_permission
    'group_resources_create'
  end

  def base_manage_permission
    'group_resources_manage'
  end
end
