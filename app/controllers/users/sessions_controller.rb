class Users::SessionsController < Devise::SessionsController
  include PublicActivity::StoreController

  after_filter :after_login, :only => :create

  def after_login
    track_activity(current_user, :login)
  end
end