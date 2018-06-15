require 'rails_helper'

RSpec.describe UserRolesController, type: :controller do
    let!(:enterprise){ create(:enterprise, cdo_name: "test") }
    let!(:user){ create(:user, enterprise: enterprise) }
    
    describe "GET#new" do
        context 'when user is logged in' do
            login_user_from_let
            before { 
                get :new
            }

            it "render new template" do
                expect(response).to render_template :new
            end
            
            it 'sets a user_role object' do
                expect(assigns[:user_role].role_name).to eq("")
            end
        end

        context 'without logged user' do
            before { get :new }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
    
    describe "POST#create" do
        describe 'when user is logged in' do
            login_user_from_let
            
            context "valid params" do
                before do
                    patch :create, user_role: {role_name: "test", role_type: "group", priority: 3}
                end

                it "redirect_to index" do
                    expect(response).to redirect_to users_url
                end

                it "creates the user_role" do
                    expect(enterprise.user_roles.last.role_name).to eq("test")
                end
            end

            context "invalid params" do
                before {
                    allow_any_instance_of(UserRole).to receive(:save).and_return(false)
                    patch :create, user_role: {role_name: "test", role_type: "group", priority: 3}
                }

                it "returns new" do
                    expect(response).to render_template(:new)
                end

                it "doesn't create the user_role" do
                    expect(enterprise.user_roles.where(:role_name => "test").count).to eq(0)
                end
            end
        end

        describe 'when user is not logged in' do
            before do
                patch :update, id: user_role.id, user_role: {role_name: "updated"}
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
    
    describe "GET#edit" do
        context 'when user is logged in' do
            login_user_from_let
            before { 
                user_role = enterprise.user_roles.last
                get :edit, :id => user_role.id 
            }

            it "render edit template" do
                expect(response).to render_template :edit
            end
            
            it 'sets a valid user_role object' do
                expect(assigns[:user_role]).to be_valid
            end
        end

        context 'without logged user' do
            before { get :edit, :id => user_role.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        describe 'when user is logged in' do
            login_user_from_let
            let(:user_role) {enterprise.user_roles.last}
            
            context "valid params" do
                before do
                    patch :update, id: user_role.id, user_role: {role_name: "TeSt"}
                end

                it "redirect_to index" do
                    expect(response).to redirect_to users_url
                end

                it "updates the user_role" do
                    user_role.reload
                    expect(user_role.role_name).to eq("TeSt")
                end
            end

            context "invalid params" do
                before {
                    allow_any_instance_of(UserRole).to receive(:update).and_return(false)
                    patch :update, id: user_role.id, user_role: {role_name: nil}
                }

                it "returns edit" do
                    expect(response).to render_template(:edit)
                end

                it "doesn't update the user_role" do
                    user_role.reload
                    expect(user_role.role_name).to_not be(nil)
                end
            end
        end

        describe 'when user is not logged in' do
            before do
                patch :update, id: user_role.id, user_role: {role_name: "updated"}
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
    
    describe "DELETE#destroy" do
        describe 'when user is logged in' do
            login_user_from_let
            let(:user_role) {enterprise.user_roles.first}
            before {
                request.env["HTTP_REFERER"] = "back"
            }
            context "valid params" do
                before do
                    delete :destroy, id: user_role.id
                end

                it "redirect_to back" do
                    expect(response).to redirect_to "back"
                end

                it "deletes the user_role" do
                    expect{UserRole.find(user_role.id)}.to raise_error(ActiveRecord::RecordNotFound)
                end
            end

            context "invalid delete" do
                before {
                    allow_any_instance_of(UserRole).to receive(:destroy).and_return(false)
                    patch :destroy, id: user_role.id, user_role: {role_name: nil}
                }

                it "redirect_to back" do
                    expect(response).to redirect_to "back"
                end

                it "doesn't delete the user_role" do
                    expect{UserRole.find(user_role.id)}.to_not raise_error
                end
            end
        end

        describe 'when user is not logged in' do
            before do
                delete :destroy, id: user_role.id
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
