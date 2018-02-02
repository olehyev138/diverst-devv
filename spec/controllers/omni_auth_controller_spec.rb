require 'rails_helper'

RSpec.describe OmniAuthController, type: :controller do
    let(:enterprise) {create :enterprise}
    let (:user) {create :user, :enterprise => enterprise}

    describe 'GET #callback' do
        context 'with logged user' do
            login_user_from_let
            before do
                request.env["omniauth.auth"] = {
                    "info" => {
                        "urls" => {
                            "public_profile" => "http://www.linkedin.com/in/netherland"
                        }
                        },
                        "provider" => "linkedin"
                    }
                get :callback, :provider => "linkedin"
            end

            it 'updates linkedin_profile_url of current user' do
                expect(assigns[:oauth]["info"]["urls"]["public_profile"]).to eq assigns[:current_user].linkedin_profile_url
            end

            it "redirects to user path" do
                expect(response).to redirect_to user_user_path(user)
            end
        end

        context 'without logged user' do
            before do
            request.env["omniauth.auth"] = {
                "info" => {
                    "urls" => {
                        "public_profile" => "http://www.linkedin.com/in/netherland"
                    }
                    },
                    "provider" => "linkedin"
                }
            get :callback, :provider => "linkedin"
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
