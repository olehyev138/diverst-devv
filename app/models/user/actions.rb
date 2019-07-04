require 'securerandom'

module User::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def send_reset_password_instructions
    raise BadRequestException.new 'Your password has already been reset. Please check your email for a link to update your password.' if self.reset_password_token.present?

    token = SecureRandom.urlsafe_base64(nil, false)
    self.reset_password_token = BCrypt::Password.create(token, cost: 11)
    self.reset_password_sent_at = Time.now
    self.save!
    # UserMailer.delay(:queue => "critical").send_reset_password_instructions(self, token)
    token
  end

  def valid_reset_password_token?(token)
    return false if token.blank?
    return false if reset_password_sent_at.blank?
    return false if Time.now - reset_password_sent_at > Rails.configuration.password_reset_time_frame.hours

    BCrypt::Password.new(reset_password_token) == token
  end

  def reset_password_by_token(user)
    self.password = user[:password]
    self.password_confirmation = user[:password_confirmation]
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    self
  end

  def invite!
    regenerate_access_token
    UserMailer.delay(queue: 'mailers').send_invitation(self)
  end

  module ClassMethods
    def base_query
      "#{self.table_name}.id LIKE :search OR LOWER(#{self.table_name}.first_name) LIKE :search OR LOWER(#{self.table_name}.last_name) LIKE :search
      OR LOWER(#{self.table_name}.email) LIKE :search"
    end

    def signin(email, password)
      # check for an email and password
      raise BadRequestException.new 'Email and password required' unless email.present? && password.present?

      # find the user
      user = User.find_by(email: email.downcase)
      raise BadRequestException.new 'User does not exist' if user.nil?

      # verify the password
      if not user.valid_password?(password)
        raise BadRequestException.new 'Incorrect password'
      end

      # auditing
      user.sign_in_count += 1
      user.last_sign_in_at = DateTime.now
      user.reset_password_token = nil
      user.reset_password_sent_at = nil
      user.save!

      user
    end

    def find_user_by_email(diverst_request, params)
      user = User.find_by_email(params[:email]&.downcase)

      raise BadRequestException.new 'User does not exist' if user.nil?

      user
    end
  end
end
