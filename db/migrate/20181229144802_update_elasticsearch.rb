class UpdateElasticsearch < ActiveRecord::Migration
  def change
    # delete all current indexes/data
    # reimport all models
    RefactorElasticsearchJob.perform_later
  end
end
