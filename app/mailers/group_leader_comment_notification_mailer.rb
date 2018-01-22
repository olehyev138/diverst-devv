class GroupLeaderCommentNotificationMailer < ApplicationMailer
    
  def notification(group, leader, count)
    @group = group
    @leader = leader
    @count = count
    
    mail(to: leader.email, subject: "#{count} Pending Comment(s) for #{group.name.titleize}")
  end
end
