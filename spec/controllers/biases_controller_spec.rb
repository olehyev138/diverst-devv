require 'rails_helper'

RSpec.describe BiasesController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: enterprise, user: user) }
    let!(:bias){ create(:bias, user: user) }

    describe "GET#index" do
        context "with logged in user" do
            login_user_from_let

            before { get :index }

            it "return success" do
                expect(response).to be_success
            end

            it "get the biases" do
               2.times { FactoryGirl.create :bias, user: user }

               expect(user.enterprise.biases.count).to eq 3
            end
        end

        context "without logged in user" do
           before { get :index }

           it "redirects user to users/sign_in path " do
                expect(response).to redirect_to new_user_session_path
           end
        end
    end

    describe "GET#new" do
        context "with logged in user" do
            login_user_from_let

            before { get :new }

            it "return success" do
                expect(response).to be_success
            end

            it "returns a new biase object for new template" do
                expect(assigns[:bias]).to be_a_new(Bias)
            end

            it "renders new template" do
                expect(response).to render_template :new
            end
        end

        context "without logged in user" do
            before { get :new }

            it "redirects user to users/sign_in path " do
                expect(response).to redirect_to new_user_session_path
            end
        end
    end

    describe 'POST#create' do
        context 'with logged user' do
            login_user_from_let

            before :each do
                request.env["HTTP_REFERER"] = "back"
            end

            context 'with correct params' do
                let(:bias_params) { FactoryGirl.attributes_for(:bias) }

                it 'redirects to correct action' do
                    post :create, bias: bias_params
                    expect(response).to redirect_to "back"
                end

                it 'creates new bias' do
                    expect{
                    post :create, bias: bias_params
                    }.to change(Bias,:count).by(1)
                end

                it "respond with flash notice message" do
                    post :create, bias: bias_params
                    expect(flash[:notice]).to eq "Bias was reported"
                end
            end

            context "with incorrect params" do
                invalid_params = { description: nil, severity: 1 }

                before { post :create, bias: invalid_params }

                it "respond with flash alert" do
                    expect(flash[:alert]).to eq "Bias was not reported. Please fix the errors"
                end

                it "renders new template" do
                    expect(response).to render_template :new
                end
            end
        end

        context "without logged in user" do
            let(:bias_params) { FactoryGirl.attributes_for(:bias) }

            before { post :create, bias: bias_params }

            it "redirect user to users/sign_in path " do
                expect(response).to redirect_to new_user_session_path
            end
        end
    end


    describe "PATCH/PUT #update" do
        context "with logged in user" do
            login_user_from_let

            context "successfully update Bias report" do
                before do
                    patch :update, id: bias.id, bias: { description: "updated version of description" }
                    bias.reload
                end

                it "should return updated description" do
                    expect(bias.description).to eq "updated version of description"
                end

                it "displays flash notice" do
                    expect(flash[:notice]).to eq "Bias report was updated"
                end

                it "redirects to action: :index" do
                    expect(response).to redirect_to(action: :index)
                end

                it "responds with status code of 200" do
                    expect(response).to have_http_status(302)
                end
            end

            context "Bias report not updated" do
                before do
                    patch :update, id: bias.id, bias: { description: nil }
                    bias.reload
                end

                it "displays a flash alert" do
                    expect(flash[:alert]).to eq "Bias report was not updated. Please fix the errors"
                end

                it "render edit template" do
                    expect(response).to render_template :edit
                end

                it "responds with status code of 200 for a successful render" do
                    expect(response).to have_http_status(200)
                end
            end
        end

        context "without logged in user" do
            let(:bias_params) { FactoryGirl.attributes_for(:bias) }

            before do
                patch :update, id: bias.id, bias: { description: "updated version of description" }
                bias.reload
            end

            it "redirect user to users/sign_in path " do
                expect(response).to redirect_to new_user_session_path
            end
        end
    end

    describe "DELETE #destroy" do
        context "with user logged in" do
            login_user_from_let

            it "deletes bias successfully" do
                expect{ delete :destroy, id: bias.id }.to change(Bias, :count).by(-1)
            end

            it "should redirect to index action after bias is successfully deleted" do
                delete :destroy, id: bias.id

                expect(response).to redirect_to action: :index
            end
        end

        context "without logged in user" do

            before { delete :destroy, id: bias.id }

            it "redirect user to users/sign_in path " do
                expect(response).to redirect_to new_user_session_path
            end
        end
    end
end