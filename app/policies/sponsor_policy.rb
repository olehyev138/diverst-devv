class SponsorPolicy < ApplicationPolicy
  def sponsor_message_visibility?
    !@record.disable_sponsor_message
  end
end
