class PopulateUserInitiativesCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :initiatives)
    end
  end
end
