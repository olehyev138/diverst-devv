class FolderSerializer < ApplicationRecordSerializer
  def excluded_keys
    [:password_digest]
  end
end
