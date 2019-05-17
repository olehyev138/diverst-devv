class CreateInvitationSegmentsGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :invitation_segments_groups do |t|
      t.belongs_to :segment
      t.belongs_to :group
    end
  end
end
