class AddColumnsToSuggestedHires < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :suggested_hires, :candidate_email
      add_column :suggested_hires, :candidate_email, :string
    end

    unless column_exists? :suggested_hires, :candidate_name
      add_column :suggested_hires, :candidate_name, :string
    end

    unless column_exists? :suggested_hires, :manager_email
      add_column :suggested_hires, :manager_email, :string
    end

    unless column_exists? :suggested_hires, :message_to_manager
      add_column :suggested_hires, :message_to_manager, :text
    end

    unless column_exists? :suggested_hires, :linkedin_profile_url
      add_column :suggested_hires, :linkedin_profile_url, :string
    end
  end
end
