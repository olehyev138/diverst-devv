class DiverstMailer < Devise::Mailer
  def invitation_instructions(record, token, opts = {})
    set_email(record, opts)
    if can_email(record)
      super
    end
  end

  def confirmation_instructions(record, token, opts = {})
    set_email(record, opts)
    if can_email(record)
      super
    end
  end

  def reset_password_instructions(record, token, opts = {})
    set_email(record, opts)
    if can_email(record)
      super
    end
  end

  def unlock_instructions(record, token, opts = {})
    set_email(record, opts)
    if can_email(record)
      super
    end
  end

  def email_changed(record, opts = {})
    set_email(record, opts)
    if can_email(record)
      super
    end
  end

  def password_change(record, opts = {})
    set_email(record, opts)
    if can_email(record)
      super
    end
  end

  def can_email(record)
    return true if record.try(:enterprise).nil?

    !record.enterprise.disable_emails?
  end

  def set_email(record, opts)
    return if record.try(:enterprise).nil?

    enterprise = record.enterprise
    from_address = Mail::Address.new enterprise.default_from_email_address.presence || 'info@diverst.com'
    from_address.display_name = enterprise.default_from_email_display_name.presence || 'Diverst'
    opts[:from] = from_address
    opts[:reply_to] = from_address

    if enterprise.redirect_all_emails? && enterprise.redirect_email_contact.present?
      record.email = enterprise.redirect_email_contact
    elsif enterprise.redirect_all_emails? && enterprise.redirect_email_contact.blank?
      # fallback
      record.email = ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com'
    end
  end
end
