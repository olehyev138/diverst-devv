require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
    let(:user){ create(:user) }

    before :each do
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "POST#create" do
        before {post :create}

        it "renders success" do
            expect(response).to redirect_to '/users/sign_in'
        end

        it "flashes" do
            expect(flash[:notice]).to eq("You will shortly receive password reset instructions to email")
        end
    end
end