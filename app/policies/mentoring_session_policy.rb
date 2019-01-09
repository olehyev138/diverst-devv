class MentoringSessionPolicy < ApplicationPolicy
    def show?
      # The user has access if they haven't declined or if they are the creator
      return true if creator?
      ! @record.mentoring_session_requests.find_by(user_id: @user.id).declined?
    end

    def edit?
      creator?
    end

    def destroy?
      edit?
    end

    def join?
      accepted_user?
    end

    def start?
      accepted_user?
    end

    def creator?
      @user.id == @record.creator_id
    end

    def accepted_user?
      return true if creator?
      @record.users.find(current_user).accepted?
    end
end
