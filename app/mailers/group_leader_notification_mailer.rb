class GroupLeaderNotificationMailer < ApplicationMailer
    
  def notification(group, leader, pending_members_count, pending_comments_count)
    @group = group
    @leader = leader
    @pending_members_count = pending_members_count
    @pending_comments_count = pending_comments_count
    @subject_line = subject
    mail(to: leader.email, subject: @subject_line)
  end
  
  def subject
    if @pending_members_count > 0 and @pending_comments_count < 1
      "#{@pending_members_count} Pending Member(s) for #{@group.name.titleize}"
    elsif @pending_members_count < 1 and @pending_comments_count > 0
      "#{@pending_comments_count} Pending Comment(s) for #{@group.name.titleize}"
    else
      "Pending Member(s) and Comment(s) for #{@group.name.titleize}"
    end
  end
end
