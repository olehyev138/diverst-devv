class AddGroupIdToEmails < ActiveRecord::Migration
  def change
    add_reference :emails, :group, index: true, after: :enterprise_id
  end
end
