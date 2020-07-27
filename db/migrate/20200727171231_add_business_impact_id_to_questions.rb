class AddBusinessImpactIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :business_impact_id, :integer
  end
end
