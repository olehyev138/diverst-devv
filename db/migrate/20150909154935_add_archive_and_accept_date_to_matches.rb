class AddArchiveAndAcceptDateToMatches < ActiveRecord::Migration[5.1]
  def change
    change_table :matches do |t|
      t.time :both_accepted_at
      t.boolean :archived, default: false
    end
  end
end
