class AddGroupIdToEmails < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy Migration
    #
    unless column_exists?(:emails, :group_id) || index_exists?(:emails, :index_emails_on_group_id)
      add_reference :emails, :group, index: true, after: :enterprise_id
    end
  end
end
