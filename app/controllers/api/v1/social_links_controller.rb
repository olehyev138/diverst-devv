class Api::V1::SocialLinksController < DiverstController
  def klass
    "SocialLink".classify.constantize
  end
end
