class NonssoActivationController < ApplicationController
  layout 'auth'

  def new
  end

  def activate
    if user = User.find_by(employee_id: params[:employee_id],
                           email: params[:email],
                           dob: params[:dob])

      user&.update notifications_email: params[:email]
    #   SendActivationLinkJob
    else
      render :new
    end
  end
end
