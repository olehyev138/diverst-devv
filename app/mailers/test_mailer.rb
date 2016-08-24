class TestMailer < ApplicationMailer
  def test(email)
    mail(to: email, subject: 'IGNORE THIS, this is just a test')
  end
end
