module HtmlSanitizingHelper
  def strip_tags(str)
    ActionController::Base.helpers.strip_tags(str)
  end
end
