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
end
