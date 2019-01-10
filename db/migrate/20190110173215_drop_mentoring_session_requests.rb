class DropMentoringSessionRequests < ActiveRecord::Migration
  def change
    drop_table :mentoring_session_requests
  end
end
