class UpdateElasticsearch < ActiveRecord::Migration[5.1]
  def change
    # delete all current indexes/data
    # reimport all models
    RefactorElasticsearchJob.perform_later
  end
end
