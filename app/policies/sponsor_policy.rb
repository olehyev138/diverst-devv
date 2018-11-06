class SponsorPolicy < ApplicationPolicy
  def sponsor_message_visibility?
    return !@record.disable_sponsor_message
  end
end
