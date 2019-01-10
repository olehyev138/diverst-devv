class MentorshipSessionPolicy < ApplicationPolicy
    def accept?
      true
    end

    def decline?
      accept?
    end
end
