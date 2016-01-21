class OmniAuthController < ApplicationController
  before_action :authenticate_user!

  def callback
    @oauth = request.env['omniauth.auth']
    self.linkedin if @oauth['provider'] == 'linkedin'
  end

  def linkedin
    picture_url = @oauth['info']['image']
    SaveEmployeeAvatarFromUrlJob.perform_later(current_employee, picture_url)
    redirect_to '/'
  end
end
