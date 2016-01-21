class OmniAuthController < ApplicationController
  before_action :authenticate_user!

  def callback
    puts "CALLBACCCK!"
    redirect_to '/'
  end
end
