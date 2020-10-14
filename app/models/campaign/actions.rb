module Campaign::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      [ :questions, :image_attachment, :banner_attachment, :groups, groups: Group.base_preloads ]
    end
  end
end
