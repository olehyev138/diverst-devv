require 'rails_helper'

RSpec.describe SegmentsController, type: :controller do
    include ApplicationHelper

    let(:enterprise) { create(:enterprise, cdo_name: "test") }
    let(:user) { create(:user, enterprise: enterprise) }
    let(:segment) { create(:segment, enterprise: enterprise) }

    login_user_from_let

    describe "GET#index" do
        it "render index template" do
            get :index
            expect(response).to render_template :index
        end

        it "returns list of segments" do
            segment
            get :index
            expect(assigns[:segments]).to eq [segment]
        end
    end


    describe "GET#new" do
        it "render new template" do
            get :new
            expect(response).to render_template :new
        end

        it "returns new segement object" do
            get :new
            expect(assigns[:segment]).to be_a_new(Segment)
        end
    end


    describe "POST#create" do
        context "successfully create" do
            let!(:segment_attributes) { FactoryGirl.attributes_for(:segment) }

            it "redirects" do
                post :create, :segment => segment_attributes
                expect(response).to redirect_to action: :index
            end

            it "creates segment" do
               expect{ post :create, :segment => segment_attributes }.to change(Segment, :count).by(1)
            end

            it "flashes a notice message" do
                post :create, :segment => segment_attributes
                expect(flash[:notice]).to eq "Your #{c_t(:segment)} was created"
            end
        end

        context "unsuccessful create" do
            let!(:invalid_segment_attributes) { { name: nil } }
            before { post :create, :segment => invalid_segment_attributes }

            it "flashes an alert message" do
                expect(flash[:alert]).to eq "Your #{c_t(:segment)} was not created. Please fix the errors"
            end

            it "renders edit template" do
                expect(response).to render_template :edit
            end
        end
    end


    describe "GET#show" do
        it "render show template" do
            get :show, :id => segment.id
            expect(response).to render_template :show
        end

        it "return members if group is absent" do
            allow_any_instance_of(Group).to receive(:present?).and_return(nil)
            segment.members << user
            get :show, :id => segment.id
            expect(segment.members.count).to eq 1
        end
    end


    describe "GET#edit" do
        it "render edit template" do
            get :edit, :id => segment.id
            expect(response).to render_template :edit
        end

        it "returns a valid segment" do 
            get :edit, :id => segment.id 
            expect(assigns[:segment]).to be_valid
        end
    end


    describe "PATCH#update" do
        context "successfully" do 
            before { patch :update, :id => segment.id, :segment => {:name => "updated"} }

            it "redirects" do
                expect(response).to redirect_to(segment)
            end

            it "creates segment" do
                segment.reload
                expect(segment.name).to eq("updated")
            end

            it "flashes a notice message" do
                expect(flash[:notice]).to eq "Your #{c_t(:segment)} was updated"
            end
        end

        context "unsuccessfully" do 
            before { patch :update, :id => segment.id, :segment => {:name => nil} }

            it "flashes an alert message" do
                expect(flash[:alert]).to eq "Your #{c_t(:segment)} was not updated. Please fix the errors"
            end

            it "render edit template" do 
                expect(response).to render_template :edit
            end
        end
    end


    describe "DELETE#destroy" do
        it "deletes segment" do
            segment
            expect{ delete :destroy, :id => segment.id }.to change(Segment, :count).by(-1)
        end

        it "redirect to action index" do
            delete :destroy, :id => segment.id
            expect(response).to redirect_to action: :index
        end
    end


    describe "GET#export_csv" do
        it "returns success" do
            get :export_csv, :id => segment.id, format: :csv
            expect(response.content_type).to eq "text/csv"
        end
    end
end
