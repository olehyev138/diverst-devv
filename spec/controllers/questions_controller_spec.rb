require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    let(:user){ create(:user) }
    let(:campaign){ create(:campaign, enterprise: user.enterprise) }
    let(:question){ create(:question, campaign: campaign) }
    login_user_from_let

    describe "GET#index" do
        context "with logged user" do
            it "gets the index" do
                get :index, campaign_id: campaign.id
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#new" do
        context "with logged user" do
            it "gets the new page" do
                get :new, campaign_id: campaign.id
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#show" do
        context "with logged user" do
            it "gets the show page" do
                get :show, id: question.id
                expect(response).to be_success
            end
        end
    end
    
    describe "POST#create" do
        context "with logged user" do
            before{ post :create, campaign_id: campaign.id, question: {title: "Title", description: "description"}}
            it "redirects" do
                expect(response).to redirect_to action: :index
            end
            
            it "creates the question" do
                campaign.reload
                expect(campaign.questions.count).to eq(1)
            end
            
            it "flashes" do
                expect(flash[:notice])
            end
        end
    end
    
    describe "PATCH#reopen" do
        context "with logged user" do
            it "gets the show page" do
                request.env["HTTP_REFERER"] = "back"
                patch :reopen, id: question.id
                expect(response).to redirect_to "back"
            end
        end
    end
    
    describe "GET#edit" do
        context "with logged user" do
            it "gets the edit page" do
                get :edit, id: question.id
                expect(response).to be_success
            end
        end
    end
    
    describe "PATCH#update" do
        context "with logged user" do
            before {patch :update, id: question.id, question: {title: "updated"}}
            
            it "redirects to the question" do
                expect(response).to redirect_to(question)
            end
            
            it "redirects to the question" do
                question.reload
                expect(question.title).to eq("updated")
            end
            
            it "flashes" do
                expect(flash[:notice])
            end
        end
    end
    
    describe "DELETE#destroy" do
        context "with logged user" do
            
            before :each do
                request.env["HTTP_REFERER"] = "back"
                delete :destroy, id: question.id
            end
            
            it "redirects" do
                expect(response).to redirect_to "back"
            end
            
            it "deletes the question" do
                expect(Question.where(:id => question.id).count).to eq(0)
            end
        end
    end
end
