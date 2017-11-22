require 'rails_helper'

RSpec.describe TopicFeedbacksController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:topic){ create(:topic, enterprise: enterprise) }
    let(:topic_feedback){ create(:topic_feedback, topic: topic) }

    login_user_from_let

    describe "GET#new" do
        it "returns success" do
            get :new, :topic_id => topic.id
            expect(response).to be_success
        end
    end

    describe "POST#create" do
        before {post :create, :topic_id => topic.id, :topic_feedback => {:content => "content"}}

        it "redirects" do
            expect(response).to redirect_to action: :thank_you
        end

        it "creates the feedback" do
            feedback = TopicFeedback.last
            expect(feedback.content).to eq("content")
        end

        it "sets the current user as the feedback user" do
            feedback = TopicFeedback.last
            expect(feedback.user.id).to eq(user.id)
        end
    end

    describe "delete#destroy" do
        before :each do
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

    describe "PATCH#update" do
        before {patch :update, :topic_id => topic.id, :id => topic_feedback.id, :topic_feedback => {:content => "updated"}}

        it "redirects" do
            expect(response).to be_ok
        end

        it "updates the feedback" do
            topic_feedback.reload
            expect(topic_feedback.content).to eq("updated")
        end
    end
end