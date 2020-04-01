class FolderSerializer < ApplicationRecordSerializer
  attributes :id, :name, :password_protected, :enterprise_id, :group_id, :parent_id, :permissions

  belongs_to :parent

  def excluded_keys
    [:password_digest]
  end
end
