module StringsHelper
  def allow_newlines(str)
    str.gsub(/\n/, '<br/>').html_safe
  end
end
