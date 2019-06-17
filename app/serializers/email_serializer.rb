class EmailSerializer < ActiveModel::Serializer
  attributes :id, :name, :enterprise_id, :created_at, :updated_at, :subject, :content,
             :mailer_name, :mailer_method, :template, :description
end
