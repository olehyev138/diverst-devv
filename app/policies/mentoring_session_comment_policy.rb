class MentoringSessionCommentPolicy < ApplicationPolicy
    def update?
      creator?
    end

    def destroy?
      creator?
    end

    def creator?
      @user.id == @record.user_id
    end
end
