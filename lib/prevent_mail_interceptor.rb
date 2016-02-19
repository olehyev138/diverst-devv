# Prevents sending email to fake, dummy data generated emails
class PreventMailInterceptor
  RE = /@enterprise[0-9]+\.com/

  def self.delivering_email(message)
    unless deliver?(message)
      message.perform_deliveries = false
      Rails.logger.debug "Interceptor prevented sending mail #{message.inspect}!"
    end
  end

  def self.deliver?(message)
    message.to.any? { |recipient| recipient !~ RE }
  end
end