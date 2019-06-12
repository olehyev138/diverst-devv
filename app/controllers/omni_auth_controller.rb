class OmniAuthController < ApplicationController
  before_action :authenticate_user!

  def callback
    linkedin if params[:provider] == 'linkedin'
  end

  def linkedin
    access = LinkedInClient.get_access_token(code: params[:code])

    token_param = "oauth2_access_token=#{access.token}"
    project_param = 'projection=(id,profilePicture(displayImage~:playableStreams))'

    temp = HTTParty.get("https://api.linkedin.com/v2/me?#{token_param}&#{project_param}") rescue 'TEMP'

    data = temp.parsed_response
    picture_url = data['profilePicture']['displayImage~']['elements'][-1]['identifiers'][0]['identifier']
    SaveUserAvatarFromUrlJob.perform_later(current_user.id, picture_url)

    redirect_to edit_linkedin_user_user_path(current_user)
  end
end
