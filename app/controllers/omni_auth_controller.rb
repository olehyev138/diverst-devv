class OmniAuthController < ApplicationController
  before_action :authenticate_employee!

  def callback
    @oauth = request.env['omniauth.auth']
    self.linkedin if @oauth['provider'] == 'linkedin'
  end

  def linkedin
    current_employee.update(
      linkedin_profile_url: @oauth['info']['urls']['public_profile']
    )

    ap @oauth['info']['urls']['public_profile']

    # Set the user's avatar
    picture_url = @oauth['info']['image']
    SaveEmployeeAvatarFromUrlJob.perform_later(current_employee, picture_url)

    redirect_to '/'
  end
end
