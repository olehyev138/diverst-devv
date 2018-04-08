require 'rails_helper'

RSpec.describe EnterprisesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: enterprise) }


    describe "GET#edit" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit, id: enterprise.id}

                it "returns edit template" do
                    expect(response).to render_template :edit
                end

                it "returns a valid enterprise object" do
                    expect(assigns[:enterprise]).to be_valid
                end
            end
        end

        describe "without a logged in user" do
            before { get :edit, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "PATCH#update" do
        describe "with logged in user" do
            before { request.env["HTTP_REFERER"] = "back" }
            login_user_from_let

            context "with valid parameters" do
                before { patch :update, id: enterprise.id, enterprise: attributes_for(:enterprise, cdo_name: "updated") }

                it "updates the enterprise" do
                    enterprise.reload
                    expect(assigns[:enterprise].cdo_name).to eq "updated"
                end

                it "redirects to action index" do
                    expect(response).to redirect_to "back"
                end

                it "flashes notice a message" do
                    expect(flash[:notice]).to eq "Your enterprise was updated"
                end
            end

            context "with invalid parameters", skip: "render params['source'] causes ActionView::MissingTemplate" do
                before { patch :update, id: enterprise.id, enterprise: { cdo_name: "" } }

                it "does not update the enterprise" do
                    enterprise.reload
                    expect(enterprise.cdo_name).to eq "test"
                end

                it "renders action edit" do
                    expect(response.status).to eq(302)
                end

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your enterprise was not updated. Please fix the errors"
                end
            end
        end

        describe "without a logged in user" do
           before { patch :update, id: enterprise.id, enterprise: attributes_for(:enterprise, cdo_name: "updated") }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#edit_fields" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit_fields, id: enterprise.id }

                it "renders edit_fields template" do
                    expect(response).to render_template :edit_fields
                end

                it "returns a valid enterprise object" do
                    expect(assigns[:enterprise]).to be_valid
                end
            end
        end

        describe "without a logged in user" do
            before { get :edit_fields, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#edit_budgeting" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit_budgeting, id: enterprise.id}

                it "renders edit_budgeting template" do
                    expect(response).to render_template :edit_budgeting
                end

                it "returns a valid enterprise object" do
                    expect(assigns[:enterprise]).to be_valid
                end

                it 'returns groups belonging to valid enterprise object' do
                    expect(assigns[:groups]).to eq enterprise.groups
                end
            end
        end

        describe "without a logged in user" do
            before { get :edit_budgeting, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    # CAN'T FIGURE OUT HOW TO PASS TEST

    describe "GET#bias" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id",
                skip: "test fails because current_user.enterpise.groups.sample.name throws an error
                in bias.html.erb"  do
                before { get :bias, id: enterprise.id }

                it "returns success" do
                    expect(response).to be_success
                end
            end
        end

        describe "without a logged in user" do
            before { get :bias, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    # CONTROLLER IS MISSING A TEMPLATE

    describe "GET#edit_cdo", skip: "tests fails because no route matches action: 'edit_cdo" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit_cdo, id: enterprise.id }

                it "returns success" do
                    expect(response).to be_success
                end

            end
        end
    end

    # CONTROLLER IS MISSING A TEMPLATE

    describe "GET#edit_mobile_fields", skip: "test fails because of Missing template layouts/handshake..." do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit_mobile_fields, id: enterprise.id }

                it "render edit_mobile_fields template" do
                    expect(response).to render_template :edit_mobile_fields
                end
            end
        end

        describe "without a logged in user" do
             before { get :edit_mobile_fields, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#edit_auth" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit_auth, id: enterprise.id}

                it "render edit_auth template" do
                    expect(response).to render_template :edit_auth
                end

                it "returns a valid enterprise object" do
                    expect(assigns[:enterprise]).to be_valid
                end
            end
        end

        describe "without a logged in user" do
            before { get :edit_auth, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#edit_branding" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do

                it "render edit_branding template" do
                    get :edit_branding, id: enterprise.id
                    expect(response).to render_template :edit_branding
                end

                it "returns a valid enterprise object" do
                    get :edit_branding, id: enterprise.id
                    expect(assigns[:enterprise]).to be_valid
                end

                context 'when enterprise has no theme' do
                    it "returns a new theme object from set_theme" do
                        get :edit_branding, id: enterprise.id
                        expect(assigns[:theme]).to be_a_new(Theme)
                    end
                end

                context 'when enterprise has a theme' do
                    before { enterprise.update(theme: create(:theme)) }

                    it 'returns a valid theme object from set_theme' do
                        pending "Circle CI can't find 'public/assets directory. This directory is 
                        currently in the gitignore file."

                        get :edit_branding, id: enterprise.id
                        expect(assigns[:enterprise].theme).to be_valid
                    end
                end
            end
        end

        describe "without a logged in user" do
            before { get :edit_branding, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    # CONTROLLER IS MISSING A TEMPLATE

    describe "GET#edit_algo", skip: "test fails because of Missing template layouts/handshake..." do
        describe "with logged in user" do
            login_user_from_let

            context "with valid id" do
                before { get :edit_algo, id: enterprise.id }

                it "render edit_algo template" do
                    expect(response).to render_template :edit_algo
                end
            end
        end

        describe "without a logged in user" do
            before { get :edit_algo, id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#update_branding" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid attributes" do
                before { patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: "#ff0000" }) }

                it "returns a valid theme object from set_theme" do
                    pending "Circle CI can't find 'public/assets directory. This directory is 
                        currently in the gitignore file."

                    expect(assigns[:theme]).to be_a_new(Theme)
                end

                it "redirect_to edit_branding" do
                    pending "Circle CI can't find 'public/assets directory. This directory is 
                        currently in the gitignore file."

                    expect(response).to redirect_to action: :edit_branding
                end

                it "flashes a notice message" do
                    pending "Circle CI can't find 'public/assets directory. This directory is 
                        currently in the gitignore file."

                    expect(flash[:notice]).to eq "Enterprise branding was updated"
                end

                it "update was successful" do
                    pending "Circle CI can't find 'public/assets directory. This directory is 
                        currently in the gitignore file."
                        
                    enterprise.reload
                    expect(enterprise.theme.primary_color).to eq "#ff0000"
                end
            end

            context "with invalid attributes" do
                before { patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: "red" }) }

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Enterprise branding was not updated. Please fix the errors"
                end

                it "render edit_branding template" do
                    expect(response).to render_template :edit_branding
                end
            end
        end

        describe "without a logged in user" do
            before { patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: "#ff0000" }) }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "PATCH#delete_attachment" do
        before { request.env["HTTP_REFERER"] = "back" }

        describe "with logged in user" do
            login_user_from_let

            context "with valid attributes" do
                before { patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: "#ff0000"}) }

                it "redirect_to back" do
                    expect(response).to redirect_to "back"
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Enterprise attachment was removed"
                end
            end

            context "with invalid attributes" do
                before do
                    allow_any_instance_of(Enterprise).to receive(:save).and_return(false)
                    patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: nil})
                end

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Enterprise attachment was not removed. Please fix the errors"
                end
            end
        end

        describe "without a logged in user" do
            before { patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: "#ff0000" }) }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#restore_default_branding" do
        before { request.env["HTTP_REFERER"] = "back" }

        describe "with logged in user" do
            login_user_from_let

            context "with valid attributes" do
                before { patch :restore_default_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: {logo_file_name: "test"})}

                it "redirect_to back" do
                    expect(response).to redirect_to "back"
                end

                it "returns a valid enterprise objec" do
                    expect(assigns[:enterprise]).to be_valid
                end
            end
        end

        describe "without a logged in user" do
            before { patch :restore_default_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: {logo_file_name: "test"})}
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#calendar" do
        it "allows view to be embed on iframe" do
            get :calendar, id: enterprise.id
            expect(response.headers).to_not include("X-Frame-Options")
        end

        it "assigns enterprise to @enterprise" do
            get :calendar, id: enterprise.id
            expect(assigns(:enterprise)).to eq enterprise
        end

        it "expect no layout" do
            expect(response).to render_template(layout: false)
        end
    end
end
