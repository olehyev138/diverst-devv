class UserGroupMailer < ApplicationMailer
  def notification(user, groups)
    @user = user
    @groups = groups
    @custom_text = user.enterprise.custom_text rescue CustomText.new
    
    set_defaults(user.enterprise, method_name)

    mail(to: @user.email, subject: @subject)
  end

  def variables
    {
      :user => @user,
      :enterprise => @user.enterprise,
      :custom_text => @custom_text
    }
  end
end
