module MailerHelper
  def html_template(enterprise, template_slug)
    email = enterprise.emails.where(slug: template_slug).first

    # Parse the custom template if one is defined. If not, return the default template
    template_string = if email
      email.custom_html_template
    else
      File.join(Rails.root, 'app', 'views', 'custom_email_templates', "#{template_slug}.html.liquid")
    end

    Liquid::Template.parse(template_string)
  end

  def subject_template(subject_string)
    email = enterprise.emails.where(slug: template_slug).first
    Liquid::Template.parse(subject_string)
  end
end
