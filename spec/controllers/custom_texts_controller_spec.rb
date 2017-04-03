require 'rails_helper'

RSpec.describe CustomTextsController, type: :controller do
  let(:user){ create(:user, enterprise: enterprise) }
  let(:enterprise){ create(:enterprise) }

  describe "GET#edit" do
    context "with logged user" do
      let(:custom_text){ create(:custom_text, enterprise: enterprise) }
      login_user_from_let

      it "assigns custom texts of enterprise's user to @custom_text" do
        get :edit, id: custom_text
        expect(assigns(:custom_text)).to eq custom_text
      end
    end
  end

  describe "PATCH#update" do
    context "with logged user" do
      login_user_from_let
      let(:custom_text){ create(:custom_text, erg: "ERG", enterprise: enterprise) }

      context "with valid params" do
        before(:each){ patch :update, id: custom_text, custom_text: { erg: "ERG 2" } }

        it "updates the custom_text" do
          custom_text.reload
          expect(custom_text.erg_text).to eq "ERG 2"
        end

        it "renders edit action" do
          expect(response).to render_template :edit
        end
      end
    end
  end
end
