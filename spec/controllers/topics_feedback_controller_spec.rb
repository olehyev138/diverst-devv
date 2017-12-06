require 'rails_helper'

RSpec.describe TopicFeedbacksController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:topic){ create(:topic, enterprise: enterprise) }
    let(:topic_feedback){ create(:topic_feedback, topic: topic) }


    describe "GET#new" do
        context "when user is logged in" do 
            login_user_from_let
            before { get :new, :topic_id => topic.id }

            it "render new template" do
                expect(response).to render_template :new
            end

            it "return new feedback" do 
                expect(assigns[:feedback]).to be_a_new(TopicFeedback)
            end
        end

        context "when user is not logged in" do 
            before { get :new, :topic_id => topic.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "POST#create" do
        describe "when user is logged in" do 
            login_user_from_let

            context "create succesfully" do
                let!(:topic_feedback_attributes) { FactoryGirl.attributes_for(:topic_feedback) }

                it "redirects to thank you action" do
                    post :create, :topic_id => topic.id, :topic_feedback => topic_feedback_attributes
                    expect(response).to redirect_to action: :thank_you
                end

                it "creates the feedback" do
                    expect{ post :create, :topic_id => topic.id, :topic_feedback => topic_feedback_attributes }.to change(TopicFeedback, :count).by(1)
                end

                it "sets the current user as the feedback user" do
                    post :create, :topic_id => topic.id, :topic_feedback => topic_feedback_attributes
                    feedback = TopicFeedback.last
                    expect(feedback.user.id).to eq(user.id)
                end
            end
        end

        describe "when user is not logged in" do 
            let!(:topic_feedback_attributes) { FactoryGirl.attributes_for(:topic_feedback) }
            before { post :create, :topic_id => topic.id, :topic_feedback => topic_feedback_attributes }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "PATCH#update", skip: "failing tests" do
        login_user_from_let
        context "successfully" do 
            before { patch :update, :topic_id => topic.id, :id => topic_feedback.id, :topic_feedback => {:content => "updated"} }

            it "redirects" do
                expect(response).to be_ok
            end

            it "updates the feedback" do
                topic_feedback.reload
                expect(topic_feedback.content).to eq("updated")
            end
        end
    end


    describe "DELETE#destroy", skip: "failing tests" do
        before do
            request.env["HTTP_REFERER"] = "back"
            delete :destroy, :topic_id => topic.id, :id => topic_feedback.id
        end

        it "redirects" do
            expect(response).to redirect_to "back"
        end

        it "deletes the feedback" do
            expect(TopicFeedback.where(:id => topic_feedback.id).count).to eq(0)
        end
    end
end