class UserGroupMailer < ApplicationMailer
  def notification(user, groups)
    @user = user
    @groups = groups

    mail(to: @user.email, subject: "You have updates in your ERGs")
  end
end
