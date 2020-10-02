class AddLinkedinUrlToSuggestedHire < ActiveRecord::Migration
  def change
    add_column :suggested_hires, :linkedin_profile_url, :string
  end
end
