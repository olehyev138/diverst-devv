class NewsLinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :group_id, :created_at, :updated_at,
             :picture_file_name, :picture_content_type, :picture_file_size, :picture_updated_at, :author_id
end
