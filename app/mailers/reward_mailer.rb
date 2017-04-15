class RewardMailer < ApplicationMailer
  def redeem_reward(responsible, user, reward)
    @user = user
    @reward = reward

    mail(to: responsible.email, subject: "A reward was redeemed")
  end
end
