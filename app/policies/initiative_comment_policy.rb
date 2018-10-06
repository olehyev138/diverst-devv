class InitiativeCommentPolicy < ApplicationPolicy
  def erg_leader?
    @user.erg_leader? && @record.present?
  end

  def approve?
  	erg_leader?
  end

  def disapprove?
  	erg_leader?
  end

  def destroy?
  	erg_leader?
  end
end