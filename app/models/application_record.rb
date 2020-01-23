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

  def self.to_query(*args)
    if args.present?
      args.map {|arg| arg.all }
    else
      self.all
    end
  end

  def self.merge_clauses(record)
    to_return, record = to_query(self, record)
    to_return.where_clause += record.where_clause
    to_return.having_clause += record.having_clause
    to_return.from_clause = record.from_clause
    to_return
  end

  def self.merge_values(record)
    to_return, record = to_query(self, record)
    to_return.order_values += record.order_values
    to_return.select_values += record.select_values
    to_return.group_values += record.group_values
    to_return.includes_values += record.includes_values
    to_return.eager_load_values += record.eager_load_values
    to_return.preload_values += record.preload_values
    to_return.references_values += record.references_values
    to_return.unscope_values += record.unscope_values
    to_return.joins_values += record.joins_values
    to_return.left_outer_joins_values += record.left_outer_joins_values
    to_return.extending_values += record.extending_values
    to_return
  end

  if Rails.env == 'development' || Rails.env == 'testing'
    def self.preload_test(preload: true, limit: 10, serializer: nil)
      arr = []
      if self.respond_to?(:base_preloads) && preload
        items = self.preload(self.base_preloads)
        if self.respond_to?(:preload_attachments)
          items = items.send_chain(self.preload_attachments.map { |field| "with_attached_#{field}" })
        end
        items = items.limit(limit)
        items.load
        p 'Preloaded'
      else
        items = self.limit(limit)
      end
      items.each do |user|
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
