class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include BaseBuilder
  include BasePager
  include BaseSearcher
  include BaseSearch
  include BaseElasticsearch
  include BaseGraph

  def self.inherited(child)
    super

    child.instance_eval do
      # Elastic search functionality!
      include Elasticsearch::Model

      index_name "#{table_name}"
      document_type "#{table_name.singularize}"
    end
  end

  after_commit on: [:create] do update_elasticsearch_index('index') end
  after_commit on: [:update] do update_elasticsearch_index('update') end
  after_commit on: [:destroy] do update_elasticsearch_index('delete') end

  if Rails.env == 'development' || Rails.env == 'testing'
    def self.preload_test(preload: true, limit: 10, serializer: nil)
      arr = []
      if self.respond_to?(:base_preloads) && preload
        users = self.preload(self.base_preloads)
        if self.respond_to?(:preload_attachments)
          users = users.send_chain(self.preload_attachments.map { |field| "with_attached_#{field}" })
        end
        users = users.limit(limit)
        users.load
        p 'Preloaded'
      else
        users = self.limit(limit)
      end
      users.each do |user|
        p "Serializing object with id = #{user.id}"
        arr << (serializer || ActiveModel::Serializer.serializer_for(user)).new(user).as_json
      end
      Clipboard.copy arr.to_json
      nil
    end
  end

  protected

  def self.sql_where(*args)
    sql = self.unscoped.where(*args).to_sql
    match = sql.match(/WHERE\s(.*)$/)
    "(#{match[1]})"
  end
end
