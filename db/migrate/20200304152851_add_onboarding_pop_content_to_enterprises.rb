class AddOnboardingPopContentToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :onboarding_pop_content, :text
  end
end
