class NonssoActivationController < ApplicationController
  layout 'auth'

  def new
  end

  def activate
    if user = User.find_by(employee_id: params[:user][:employee_id],
                           email: params[:user][:email],
                           dob: params[:user][:dob])

      user&.update notifications_email: params[:email]
      flash[:notice] = 'You will receive an email shortly with a link to activate your account.'
      user.invite!
      render :new
    else
      render :new
    end
  end
end
