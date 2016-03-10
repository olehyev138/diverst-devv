module MailerHelper
  def html_template(enterprise, template_slug)
    email = email_for(enterprise: enterprise, slug: template_slug)

    # Parse the custom template if one is defined. If not, return the default template
    template_string = if email.use_custom_templates?
      email.custom_html_template
    else
      File.read File.join(Rails.root, 'app', 'views', 'default_email_templates', "#{template_slug}.html.liquid")
    end

    Liquid::Template.parse(template_string)
  end

  def subject_template(enterprise, template_slug)
    email = email_for(enterprise: enterprise, slug: template_slug)
    Liquid::Template.parse(email.subject)
  end

  private

  def email_for(enterprise:, slug:)
    email = enterprise.emails.where(slug: slug).first
  end
end
