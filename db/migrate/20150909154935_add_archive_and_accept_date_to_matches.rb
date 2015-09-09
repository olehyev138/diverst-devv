class AddArchiveAndAcceptDateToMatches < ActiveRecord::Migration
  def change
    change_table :matches do |t|
      t.time :both_accepted_at
      t.boolean :archived, default: false
    end
  end
end
