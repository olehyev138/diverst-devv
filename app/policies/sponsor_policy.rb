class SponsorPolicy < ApplicationPolicy
  def sponsor_message_visibility?
        case @record.disable_sponsor_message
        when true #i.e  when disable_sponsor_message is true return false for this policy
            return false
        when false #i.e when disable_sponsor_message is false return true for this policy
            return true
        end
    end
end