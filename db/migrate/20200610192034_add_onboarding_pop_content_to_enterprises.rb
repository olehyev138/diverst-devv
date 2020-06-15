class AddOnboardingPopContentToEnterprises < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :enterprises, :onboarding_pop_up_content
      add_column :enterprises, :onboarding_pop_up_content, :text
    end
  end
end
