module Onboard
  extend ActiveSupport::Concern

  def resend_invite?(resource)
    # Determine whether this user is in the system but has not yet accepted there invitation
    resource.present? && resource.invitation_accepted_at.nil?
  end
end
