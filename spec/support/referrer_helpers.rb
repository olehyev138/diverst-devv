module ReferrerHelpers
  DEFAULT_REFERRER = ''

  def set_referrer(referer_path = '')
    referer = referer_path || DEFAULT_REFERRER
    request.env['HTTP_REFERER'] = referer
  end

  def default_referrer
    DEFAULT_REFERRER
  end
end
