class BaseClass < ActiveRecord::Base
  self.abstract_class = true

  include ::BaseSearch
  include ::BaseElasticsearch
  include ::BaseGraph

  def update_elasticsearch_index(action)
    IndexElasticsearchJob.perform_later(self.class.name, id, action)
  end

  def self.inherited(child)
    super
    child.instance_eval do
      include Elasticsearch::Model

      index_name "#{table_name}"
      document_type "#{table_name.singularize}"
    end
  end

  after_commit on: [:create] {update_elasticsearch_index("index")}
  after_commit on: [:update] {update_elasticsearch_index("update")}
  after_commit on: [:destroy] {update_elasticsearch_index("delete")}
end
