require 'rails_helper'

RSpec.describe Initiatives::UpdatesController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:initiative){ initiative_of_group(group) }
    let(:initiative_update) {create :initiative_update, initiative: initiative}

    login_user_from_let

    describe 'GET#index' do
        it "gets the updates" do
            get :index, group_id: group.id, initiative_id: initiative.id
            expect(response).to be_success
        end
    end

    describe 'GET#new' do
        it "gets a new update" do
            get :new, group_id: group.id, initiative_id: initiative.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#edit' do
        it "edits an update" do
            get :edit, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id
            expect(response).to be_success
        end
    end
    
    describe 'POST#create' do
        context "when successful" do 
            before{post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: {report_date: Date.today}}
            
            it "redirects" do
                expect(response).to redirect_to action: :index
            end
            
            it "creates the initiative_update" do
                expect(InitiativeUpdate.count).to eq(1)
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq("Your initiative update was created")
            end
            
            it "sets the owner" do
                expect(InitiativeUpdate.last.owner).to eq(user)
            end
        end
        
        context "when unsuccessful" do 
            before{
                allow_any_instance_of(InitiativeUpdate).to receive(:save).and_return(false)
                post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: {report_date: Date.today}
            }
            
            it "renders new" do
                expect(response).to render_template :new
            end
            
            it "does not create the initiative_update" do
                expect(InitiativeUpdate.count).to eq(0)
            end
            
            it "flashes" do
                expect(flash[:alert]).to eq("Your initiative update was not created. Please fix the errors")
            end
        end
    end

    describe 'GET#show' do
        it "gets an update" do
            get :show, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id
            expect(response).to be_success
        end
    end

    describe 'PATCH#update' do
        
        context "when successful" do
            before{patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id, initiative_update: {report_date: Date.today}}
            
            it "redirects" do
                expect(response).to redirect_to action: :index
            end
            
            it "updates the initiative_update" do
                initiative_update.reload
                expect(initiative_update.report_date).to eq(Date.today)
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq("Your initiative update was updated")
            end
        end
        
        context "when usuccessful" do
            before{
                allow_any_instance_of(InitiativeUpdate).to receive(:update).and_return(false)
                patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id, initiative_update: {report_date: Date.today}
            }
            
            it "renders edit" do
                expect(response).to render_template :edit
            end
            
            it "flashes" do
                expect(flash[:alert]).to eq("Your initiative update was not updated. Please fix the errors")
            end
        end
    end

    describe 'DELETE#destroy' do

        before {delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id}

        it "redirects" do
            expect(response).to redirect_to action: :index
        end

        it "deletes the initiative_update" do
            expect(InitiativeUpdate.where(:id => initiative_update.id).count).to eq(0)
        end
    end
end