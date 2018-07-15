require 'rails_helper'

RSpec.describe SubSegmentsController, type: :controller do
    let(:enterprise){ create(:enterprise, name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:segment){ create(:segment, enterprise: enterprise) }

    login_user_from_let

     describe "GET#new" do
        before { get :new, :segment_id => segment.id }

        it "returms a new sub segment object" do
            expect(assigns[:sub_segment]).to be_a_new(Segment)
        end

        it "render new template" do
            expect(response).to render_template :new
        end
    end


    describe "POST#create" do
        context "successfully" do
            before { post :create, :segment_id => segment.id, :segment => {:name => "test"} }

            it "redirects" do
                expect(response).to redirect_to segment
            end

            it "creates segment" do
                last_segment = Segment.last
                expect(last_segment.name).to eq("test")
            end

            it "flashes a notice message" do
                expect(flash[:notice]).to eq "Your sub-segment was created"
            end

            it "increments sub_segments count" do
                expect(segment.sub_segments.count).to eq(1)
            end

            it "sets parent and child relationship" do
                child = Segment.last

                expect(child.parent.id).to eq(segment.id)
            end
        end

        context "unsuccessfully" do
             before do
                 request.env["HTTP_REFERER"] = "back"
                 post :create, :segment_id => segment.id, :segment => {:name => nil}
             end

             it "flashes an alert message" do
                expect(flash[:alert]).to eq "Your sub-segment was not created. Please fix the errors"
             end

             it "redirect to back" do
                expect(response).to redirect_to "back"
             end
        end
    end
end
