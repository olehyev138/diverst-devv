class User::MessagesController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def index
    @messages = current_user.messages.order(created_at: :desc)
  end
end
