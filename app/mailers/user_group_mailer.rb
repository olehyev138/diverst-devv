class UserGroupMailer < ApplicationMailer
  def notification(user, groups)
    @user = user
    @groups = groups
    @custom_text = user.enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification
    return if @user.enterprise.disable_emails?

    @groups_info = {
      initiatives: [],
      news_links: [],
      messages: [],
      social_links: []
    }

    @groups.each do |group|
      @groups_info[:initiatives] << group[:events]
      @groups_info[:news_links] << group[:news]
      @groups_info[:messages] << group[:messages]
      @groups_info[:social_links] << group[:social_links]
    end

    @groups_info[:initiatives].flatten!
    @groups_info[:news_links].flatten!
    @groups_info[:messages].flatten!
    @groups_info[:social_links].flatten!

    @enterprise = @user.enterprise
    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
    @user.update last_group_notification_date: DateTime.now
  end

  def variables
    {
      user: @user,
      enterprise: @user.enterprise,
      custom_text: @custom_text
    }
  end
end
