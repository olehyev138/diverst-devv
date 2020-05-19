class SocialLinkPolicy < GroupBasePolicy
  def base_index_permission
    'social_links_index'
  end

  def base_create_permission
    'social_links_create'
  end

  def base_manage_permission
    'social_links_manage'
  end

  def update?
    record.author === user || super
  end

  def destroy?
    record.author === user || super
  end

  class Scope < Scope
    def index?
      SocialLinkPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(author_id: user.id)
      else
        scope.none
      end
    end
  end
end
