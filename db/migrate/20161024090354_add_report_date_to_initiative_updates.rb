class AddReportDateToInitiativeUpdates < ActiveRecord::Migration
  def change
    change_table :initiative_updates do |t|
      t.datetime :report_date
    end
  end
end
