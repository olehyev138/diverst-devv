require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    let(:user){ create(:user) }
    let(:campaign){ create(:campaign, enterprise: user.enterprise) }
    let(:question){ create(:question, campaign: campaign) }

    describe "GET#index" do
        context "with logged user" do
            login_user_from_let
            before { get :index, campaign_id: campaign.id }

            it "gets the index" do
                expect(response).to render_template :index
            end

            it "returns a valid campaign object" do
                expect(assigns[:campaign]).to be_valid
            end

            it "list campaign questions in descending order by created_at" do
                question
                question1 = create(:question, campaign: campaign)
                question2  = create(:question, campaign: campaign)

                expect(assigns[:campaign].questions).to eq [question, question1, question2]
            end
        end

        context "without a logged in user" do
            before { get :index, campaign_id: campaign.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#new" do
        context "with logged user" do
            login_user_from_let
            before { get :new, campaign_id: campaign.id }

            it "gets the new page" do
                expect(response).to render_template :new
            end

            it "returns a valid campaign object" do
                expect(assigns[:question].campaign).to be_valid
            end

            it "returns a new question object" do
                expect(assigns[:question]).to be_a_new(Question)
            end
        end

        context "without a logged in user" do
            before { get :new, campaign_id: campaign.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#show" do
        context "with logged user" do
            login_user_from_let
            before { get :show, id: question.id }

            it "gets the show page" do
                expect(response).to render_template :show
            end

            it "returns a valid campaign object" do
                expect(assigns[:question].campaign).to be_valid
            end
        end

        context "without a logged in user" do
            before { get :show, id: question.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "POST#create" do
        context "with logged user" do
            login_user_from_let
            
            context "when successful" do
                before{ post :create, campaign_id: campaign.id, question: {title: "Title", description: "description"}}
    
                it "redirects" do
                    expect(response).to redirect_to action: :index
                end
    
                it "creates the question" do
                    campaign.reload
                    expect(campaign.questions.count).to eq(1)
                end
    
                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Your question was created"
                end
            end
            context "when unsuccessful" do
                before{ 
                    allow_any_instance_of(Question).to receive(:save).and_return(false)
                    post :create, campaign_id: campaign.id, question: {title: "Title", description: "description"}
                }
    
                it "renders new" do
                    expect(response).to render_template :new
                end
    
                it "does not create the question" do
                    campaign.reload
                    expect(campaign.questions.count).to eq(0)
                end
    
                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your question was not created. Please fix the errors"
                end
            end
        end

        context "without a logged in user" do
            before { post :create, campaign_id: campaign.id, question: {title: "Title", description: "description"} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#reopen" do
        context "with logged user" do
            login_user_from_let
            it "gets the show page" do
                request.env["HTTP_REFERER"] = "back"
                patch :reopen, id: question.id
                expect(response).to redirect_to "back"
            end
        end
    end

    describe "GET#edit" do
        context "with logged user" do
            login_user_from_let
            it "gets the edit page" do
                get :edit, id: question.id
                expect(response).to be_success
            end
        end

         context "without a logged in user" do
            before { get :edit, id: question.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        context "with logged user" do
            login_user_from_let
            context "when successful" do
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
            context "when unsuccessful" do
                before {
                    allow_any_instance_of(Question).to receive(:save).and_return(false)
                    patch :update, id: question.id, question: {title: "updated"}
                }
    
                it "redirects to the question" do
                    expect(response).to render_template :edit
                end
    
                it "does not update the question" do
                    question.reload
                    expect(question.title).to_not eq("updated")
                end
    
                it "flashes an alert" do
                    expect(flash[:alert]).to eq("Your question was not updated. Please fix the errors")
                end
            end
        end

        context "without a logged in user" do
            before { patch :update, id: question.id, question: {title: "updated"} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "DELETE#destroy" do
        context "with logged user" do
            login_user_from_let

            before do
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

        context "without a logged in user" do
            before { delete :destroy, id: question.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
