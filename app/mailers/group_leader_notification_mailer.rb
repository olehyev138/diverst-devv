class GroupLeaderNotificationMailer < ApplicationMailer
    
  def notification(group, leader, count)
    @group = group
    @leader = leader
    @count = count
    
    mail(to: leader.email, subject: "#{count} Pending Member(s) for #{group.name.titleize}")
  end
end
