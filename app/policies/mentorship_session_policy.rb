class MentorshipSessionPolicy < ApplicationPolicy
  def accept?
    # Can only accept if it's pending AND they're not the creator of the session AND it is their invite
    @record.pending? && !creator? && @user.id == @record.user_id
  end

  def decline?
    accept?
  end

  def creator?
    @user.id == @record.mentoring_session.creator_id
  end
end
