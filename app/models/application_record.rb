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
      args.map { |arg| arg.all }
    else
      self.all
    end
  end

  def self.summ(column)
    query = to_query
    if query.distinct_value
      query.klass
          .unscoped
          .select("SUM(#{column}) as total_sum")
          .from(query.select("#{table_name}.id, #{table_name}.#{column}"))[0]
          .total_sum
    else
      query.sum(column)
    end
  end

  def self.sum_and_count(column)
    query = to_query
    if query.distinct_value
      query = query.klass
                  .unscoped
                  .select("SUM(#{column}) as total_sum, COUNT(id) as total_count")
                  .from(query.select("#{table_name}.id, #{table_name}.#{column}"))[0]
    else
      query = query.select("SUM(#{table_name}.#{column}) as total_sum, COUNT(#{table_name}.id) as total_count")[0]
    end
    [query.total_sum, query.total_count]
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
