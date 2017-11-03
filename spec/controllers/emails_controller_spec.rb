require 'rails_helper'

RSpec.describe EmailsController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    
    describe "GET#index" do 
        context "with logged in user" do 
          login_user_from_let

          before { get :index }

          it "render index template" do 
              expect(response).to eq render_template :index
          end

          it "return enterprise of current user" do 
              expect(assigns[:enterprise]).to user.enterpise
          end
        end
    end
     
    describe "PATCH#update" do
        let(:email){ create(:email, enterprise: enterprise) }
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid parameters" do
                before(:each){ patch :update, id: email.id, email: {subject: "updated"}}
                
                it "updates the email" do
                    email.reload
                    expect(email.subject).to eq "updated"
                end
                
                it "redirects to action index" do
                    expect(response).to redirect_to action: :index
                end
                
                it "flashes notice" do 
                    expect(flash[:notice])
                end
            end
        end
    end
end
