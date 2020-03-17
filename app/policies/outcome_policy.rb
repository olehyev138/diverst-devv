class OutcomePolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_manage'
  end

  def base_manage_permission
    'initiatives_manage'
  end
end
