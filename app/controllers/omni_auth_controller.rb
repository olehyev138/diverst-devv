class OmniAuthController < ApplicationController
  before_action :authenticate_user!

  def callback
    @oauth = request.env['omniauth.auth']
    linkedin if @oauth['provider'] == 'linkedin'
  end

  def linkedin
    current_user.update(
      linkedin_profile_url: @oauth['info']['urls']['public_profile']
    )

    # Set the user's avatar
    picture_url = @oauth['info']['image']
    SaveUserAvatarFromUrlJob.perform_later(current_user, picture_url)

    redirect_to user_user_path(current_user)
  end
end
