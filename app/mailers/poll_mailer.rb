class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @user = user
    @poll = poll
    @enterprise = @user.enterprise
    @custom_text = @enterprise.custom_text rescue CustomText.new

    set_defaults(@enterprise, method_name)
    
    mail(to: @user.email, subject: @subject)
  end
  
  def variables
    {
      :user => @user,
      :survey => @poll,
      :enterprise => @enterprise,
      :custom_text => @custom_text,
      :click_here => "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>",
    }
  end
  
  def url
    new_poll_poll_response_url(@poll)
  end
end
