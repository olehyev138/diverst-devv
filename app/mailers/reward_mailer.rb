class RewardMailer < ApplicationMailer
  def redeem_reward(responsible, user, reward)
    @user = user
    @reward = reward
    
    set_defaults(@user.enterprise, method_name)

    mail(from: @from_address, to: responsible.email, subject: "A reward was redeemed")
  end
end
