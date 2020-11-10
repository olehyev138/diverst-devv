module NewsLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      case diverst_request.action
      when 'index' then [:author, :picture_attachment, :picture_blob, :photos, :group]
      when 'show', 'create', 'update'
        [
            :author,
            :group,
            :comments,
            :photos,
            :picture_attachment, :picture_blob,
            comments: GroupMessageComment.base_preloads(diverst_request)
        ]
      else []
      end
    end
  end
end
