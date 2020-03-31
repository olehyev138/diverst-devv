class NonssoActivationController < ApplicationController
  layout 'auth'

  def new
  end

  def activate
    if user = User.find_by(
                           email: params[:user][:email])

      user&.update notifications_email: params[:email]
      flash[:notice] = 'You will receive an email shortly with a link to activate your account.'
      user.invite!
      render :new
    else
      render :new
    end
  end
end
