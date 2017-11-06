require 'rails_helper'

RSpec.describe EmailsController, type: :controller do
    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, enterprise: enterprise) }
    
    describe "GET#index" do 
        context "with logged in user" do 
          login_user_from_let

          before { get :index }

          it "render index template" do 
              expect(response).to render_template :index
          end

          it "return enterprise of current user" do 
              expect(assigns[:enterprise]).to eq user.enterprise
          end

          it "returns emails belonging to enterprise" do 
              2.times { FactoryGirl.create(:email, enterprise: enterprise) }

              expect(enterprise.emails.count).to eq 2
          end
        end

        context "without a logged in user" do 
            before { get :index }

             it "redirect user to users/sign_in path " do 
                expect(response).to redirect_to new_user_session_path
            end

            it 'returns status code of 302' do
                expect(response).to have_http_status(302)
            end
        end
    end
     
    describe "PATCH#update" do
        let(:email) { create(:email, enterprise: enterprise) }
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid parameters" do
                before { patch :update, id: email.id, email: { subject: "updated" } }
                
                it "updates the email" do
                    email.reload
                    expect(email.subject).to eq "updated"
                end
                
                it "redirects to action index" do
                    expect(response).to redirect_to action: :index
                end
                
                it "flashes a notice message" do 
                    expect(flash[:notice]).to eq "Your email was updated"
                end
            end

            context "with invalid parameters" do 
               before { patch :update, id: email.id, email: { subject: nil } }

              it "flashes an alert message" do 
                  email.reload
                  expect(flash[:alert]).to eq "Your email was not updated. Please fix the errors"
              end

              it "renders edit template" do 
                  expect(response).to render_template :edit 
              end
            end
        end

        describe "without a logged in user" do 
          before { patch :update, id: email.id, email: {subject: "updated"} }

          it "redirect user to users/sign_in path " do 
            expect(response).to redirect_to new_user_session_path
          end

          it 'returns status code of 302' do
            expect(response).to have_http_status(302)
          end
        end
    end
end
