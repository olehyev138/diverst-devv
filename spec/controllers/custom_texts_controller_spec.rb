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
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe "PATCH#update" do
    let(:custom_text) { create(:custom_text, erg: "ERG", enterprise: enterprise) }

    context "with logged user" do
      login_user_from_let

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

      # this context fails because CustomText model has no validation
      context "with invalid params" do
        before { 
          allow_any_instance_of(CustomText).to receive(:update).and_return(false)
          patch :update, id: custom_text, custom_text: { erg: nil } 
        }

        it "flashes an alert message" do
          expect(flash[:alert]).to eq "Your texts were not updated. Please fix the errors"
        end
      end
    end

    context "without logged in user" do
        before { patch :update, id: custom_text, custom_text: { erg: "ERG 2" } }
        it_behaves_like "redirect user to users/sign_in path"
    end
  end
end
