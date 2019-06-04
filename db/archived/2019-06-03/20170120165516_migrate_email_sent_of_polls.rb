class MigrateEmailSentOfPolls < ActiveRecord::Migration[5.1]
  class MigrationPolls < ActiveRecord::Base
    self.table_name = :polls
  end

  def up
    MigrationPolls.update_all(email_sent: true)
  end

  def down
    MigrationPolls.update_all(email_sent: false)
  end
end
