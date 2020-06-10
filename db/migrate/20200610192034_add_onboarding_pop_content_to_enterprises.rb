class AddOnboardingPopContentToEnterprises < ActiveRecord::Migration[5.2]
  def change
    add_column :enterprises, :onboarding_pop_up_content, :text
  end
end
