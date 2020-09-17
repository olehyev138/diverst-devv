# Preview all emails at http://localhost:3000/rails/mailers/suggested_hire_mailer
class SuggestedHireMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/suggested_hire_mailer/suggest_hire
  def suggest_hire
    SuggestedHireMailer.suggest_hire
  end

end
