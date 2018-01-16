require 'rails_helper'

RSpec.describe OmniAuthController, type: :controller do
    let(:enterprise) {create :enterprise}
    let (:user) {create :user, :enterprise => enterprise}

    describe 'GET #callback' do
        login_user_from_let

        it "redirects to user path" do
            request.env["omniauth.auth"] = {
                "info" => {
                    "urls" => {
                        "public_profile" => ""
                    }
                },
                "provider" => "linkedin"
            }
            get :callback, :provider => "linkedin"
            expect(response).to redirect_to user_user_path(user)
        end
    end
end
