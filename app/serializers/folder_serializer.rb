class FolderSerializer < ApplicationRecordSerializer
  attributes :id, :name, :password_protected, :enterprise_id, :group_id, :parent_id, :permissions, :parent

  def policies
    super + [:archive?]
  end

  def excluded_keys
    [:password_digest]
  end
end
