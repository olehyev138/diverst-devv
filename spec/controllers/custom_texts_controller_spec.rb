require 'rails_helper'

RSpec.describe CustomTextsController, type: :controller do
  let(:user){ create(:user, enterprise: enterprise) }
  let(:enterprise){ create(:enterprise) }

  describe "GET#edit" do
    let(:custom_text){ create(:custom_text, enterprise: enterprise) }

    context "with logged user" do
      login_user_from_let
      before { get :edit, id: custom_text }

      it "assigns custom texts of enterprise's user to @custom_text" do
        expect(assigns(:custom_text)).to eq custom_text
      end

      it "renders edit template" do 
        expect(response).to render_template :edit
      end
    end

    context 'without logged user' do
      before { get :edit, id: custom_text }

      it "redirect user to users/sign_in path " do 
        expect(response).to redirect_to new_user_session_path
      end

      it 'returns status code of 302' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "PATCH#update" do
    context "with logged user" do
      login_user_from_let
      let(:custom_text){ create(:custom_text, erg: "ERG", enterprise: enterprise) }

      context "with valid params" do
        before { patch :update, id: custom_text, custom_text: { erg: "ERG 2" } }

        it "updates the custom_text" do
          custom_text.reload
          expect(custom_text.erg_text).to eq "ERG 2"
        end

        it "renders edit action" do
          expect(response).to render_template :edit
        end
        
        it "flashes a notice message" do
          expect(flash[:notice]).to eq "Your texts were updated"
        end
      end

      context "with invalid params" do 
        before { patch :update, id: custom_text, custom_text: { erg: nil } }

        it "flashes an alert message" do 
          expect(flash[:alert]).to eq "Your texts were not updated. Please fix the errors"
        end
      end
    end
  end
end
