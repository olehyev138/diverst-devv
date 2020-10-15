class AddBusinessImpactIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :questions, :business_impact_id
      add_column :questions, :business_impact_id, :integer
    end
  end
end
