class AlternativeActivationController < ApplicationController
  layout 'auth'

  def new
  end

  def activate
    dob = activation_params[:dob]
    notifications_email = activation_params[:notifications_email]
    user = User.find_by(email: activation_params[:email])

    if user.present?
      user_dob = user.birthday

      if user_dob == dob
        user&.update notifications_email: activation_params[:notifications_email]
        flash[:notice] = 'You will receive an email shortly with a link to activate your account.'
        user&.invite!
        render :new
      else
        flash[:alert] = 'Incorrect credentials or account does not exists'
        render :new
      end
    else
      flash[:alert] = 'Incorrect credentials or account does not exists'
      render :new
    end
  end

  private

  def activation_params
    params.require(:user).permit(:notifications_email, :email, :dob)
  end
end
