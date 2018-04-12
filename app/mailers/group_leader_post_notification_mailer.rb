class GroupLeaderPostNotificationMailer < ApplicationMailer
    
  def notification(group, leader, count)
    @group = group
    @leader = leader
    @count = count
    
    url = group_posts_url(@group)
    @mailer_text = group.enterprise.group_leader_post_mailer_notification_text  % { user_name: leader.name, group_name: group.name, click_here: "<a saml_for_enterprise=\"#{@group.enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>" }
    
    mail(to: leader.email, subject: "#{count} Pending Post(s) for #{group.name.titleize}")
  end
end
