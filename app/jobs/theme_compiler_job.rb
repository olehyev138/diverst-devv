class ThemeCompilerJob < ActiveJob::Base
  queue_as :default

  def perform(theme_id, enterprise_id)
    theme = Theme.find_by_id(theme_id)
    return if theme.nil?

    ThemeCompiler.new(theme).compute
    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise.nil?

    enterprise.theme_id = theme_id
    enterprise.save!
  end
end
