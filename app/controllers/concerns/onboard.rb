module Onboard
  extend ActiveSupport::Concern

  def resend_invite?
    # Determine whether this user is in the system but has not yet accepted there invitation
    self.resource.present? and self.resource.invitation_accepted_at.nil?
  end
end
