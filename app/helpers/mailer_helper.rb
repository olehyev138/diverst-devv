module MailerHelper
  def html_template(enterprise, template_slug)
    email = enterprise.emails.where(slug: template_slug).first

    # Parse the custom template if one is defined. If not, return the default template
    if email
      template_string = email.custom_html_template
    else
      template_string = File.join(Rails.root, 'app', 'views', 'custom_email_templates', "#{template_slug}.html.liquid")
    end

    Liquid::Template.parse(template_string)
  end
end
