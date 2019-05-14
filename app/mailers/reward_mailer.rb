class RewardMailer < ApplicationMailer
  def redeem_reward(responsible, user, reward)
    @user = user
    @reward = reward
    @email = responsible.email
    return if @user.enterprise.disable_emails?

    set_defaults(@user.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: 'A reward was redeemed')
  end
end
