module ControllerMacros
  def login_user(user=nil)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user ||= FactoryGirl.create(:user)

      sign_in user
    end
  end

  def login_user_from_let
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
end
