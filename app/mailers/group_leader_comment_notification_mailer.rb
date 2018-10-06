class GroupLeaderCommentNotificationMailer < ApplicationMailer
    
  def notification(group, leader, count)
    @group = group
    @leader = leader
    @count = count
    
    set_defaults(@leader.enterprise, method_name)
    
    mail(from: @from_address, to: leader.email, subject: "#{count} Pending Comment(s) for #{group.name.titleize}")
  end
end
