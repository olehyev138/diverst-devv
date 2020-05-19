class GroupMessagePolicy < GroupBasePolicy
  def base_index_permission
    'group_messages_index'
  end

  def base_create_permission
    'group_messages_create'
  end

  def base_manage_permission
    'group_messages_manage'
  end

  def update?
    record.author === user || super
  end

  def destroy?
    record.author === user || super
  end
end
