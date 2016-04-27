class AddInviteesToEvents < ActiveRecord::Migration
  def change
    create_table :event_invitees do |t|
      t.belongs_to :event
      t.belongs_to :user
    end
  end
end
