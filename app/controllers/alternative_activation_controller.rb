class AlternativeActivationController < ApplicationController
  layout 'auth'

  def new
  end

  def activate
    dob = params[:user][:dob]
    notifications_email = params[:user][:notifications_email]
    user = User.find_by(email: params[:user][:email])

    if user
      user_dob = user.birthday

      if user_dob == dob
        user&.update notifications_email: params[:notifications_email]
        flash[:notice] = 'You will receive an email shortly with a link to activate your account.'
        user&.invite!
        render :new
      else
        flash[:alert] = 'Your account does not exists'
        render :new
      end
    else
      flash[:alert] = 'Your account does not exists'
      render :new
    end
  end
end
