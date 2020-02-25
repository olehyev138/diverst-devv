class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include BaseBuilder
  include BasePager
  include BaseSearcher
  include BaseSearch
  include BaseElasticsearch
  include BaseGraph
  include BaseCsvExport

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

  if Rails.env.development?
    def self.preload_test(preload: true, limit: 10, serializer: nil)
      arr = []
      if self.respond_to?(:base_preloads) && preload
        items = self.preload_all
        items = items.limit(limit)
        items.load
        p 'Preloaded'
      else
        items = self.limit(limit)
      end
      items.each do |item|
        p "Serializing object with id = #{item.id}"
        arr << (serializer || ActiveModel::Serializer.serializer_for(item)).new(item).as_json
      end
      Clipboard.copy arr.to_json
      nil
    end
  end

  def self.preload_all
    preload(base_preloads || [])
  end

  protected

  def self.sql_where(*args)
    sql = self.unscoped.where(*args).to_sql
    match = sql.match(/WHERE\s(.*)$/)
    "(#{match[1]})"
  end
end
