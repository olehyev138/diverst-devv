class GroupSocialLinkPolicy < GroupBasePolicy
    def base_index_permission
      "social_links_index"
    end
    
    def base_create_permission
      "social_links_create"
    end
    
    def base_manage_permission
      "social_links_manage"
    end
    
    def index?
      case group.latest_news_visibility
      when 'public'
          # Everyone can see latest news
          user.policy_group.group_posts_index?
      else
        super
      end
    end
end
