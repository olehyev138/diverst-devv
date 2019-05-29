class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  #  include BaseBuilder
  #  include BasePager
  #  include BaseSearcher

  include ::BaseSearch
  include ::BaseElasticsearch
  include ::BaseGraph


  def self.inherited(child)
    super

    child.instance_eval do
      # Elastic search functionality!
      include Elasticsearch::Model

      index_name "#{table_name}"
      document_type "#{table_name.singularize}"
    end
  end

  # TODO: puma wont run with {} ?
  after_commit on: [:create] do update_elasticsearch_index('index') end
  after_commit on: [:update] do update_elasticsearch_index('update') end
  after_commit on: [:destroy] do update_elasticsearch_index('delete') end
end
