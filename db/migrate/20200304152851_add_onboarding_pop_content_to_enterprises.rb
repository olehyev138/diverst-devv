class AddOnboardingPopContentToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :onboarding_pop_up_content, :text
  end
end
