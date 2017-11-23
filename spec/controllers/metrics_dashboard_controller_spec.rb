require 'rails_helper'

RSpec.describe MetricsDashboardsController, type: :controller do
  let(:enterprise) { create :enterprise }
  let (:user) { create :user, :enterprise => enterprise }
  let(:metrics_dashboard) { create :metrics_dashboard, :enterprise => enterprise }

  describe 'GET #new' do
    def get_new
      get :new
    end

    context 'with logged user' do
      login_user_from_let

      before { get_new }

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "return new metric dashboard object" do
        expect(assigns[:metrics_dashboard]).to be_a_new(MetricsDashboard)
      end
    end

    context 'without logged user' do
      before { get_new }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      login_user_from_let

      before { get_index }

      it "return metrics" do
        2.times { create :metrics_dashboard, :enterprise => enterprise }
        metrics_dashboard
        expect(MetricsDashboard.all.count).to eq 3
      end

      it "render index template" do
        expect(response).to render_template :index
      end

      it "return enterprise belonging to current_user" do
        expect(enterprise.users).to include user
      end
    end

    context 'without logged user' do
      before { get_index }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'POST #create' do
    def post_create(params={a: 1})
      post :create, metrics_dashboard: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      let(:md_params) { attributes_for :metrics_dashboard, enterprise: user.enterprise, group_ids: [create(:group).id] }

      login_user_from_let

      context 'with correct params' do
        it 'creates metrics dashboard' do
          expect{
            post_create(md_params)
          }.to change(MetricsDashboard, :count).by(1)
        end

        it "flashes a notice message" do
          post_create(md_params)
          expect(flash[:notice]).to eq "Your dashboard was created"
        end

        it "redirect to just created metrics dashboard" do
          post_create(md_params)
          expect(response).to redirect_to MetricsDashboard.last
        end

        it 'creates correct dashboard' do
          post_create(md_params)

          new_md = MetricsDashboard.last

          expect(new_md.enterprise).to eq user.enterprise
          expect(new_md.name).to eq md_params[:name]
        end

        it 'redirects to correct action' do
          post_create(md_params)
          expect(response).to redirect_to MetricsDashboard.last
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              post_create(md_params)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { MetricsDashboard.last }
            let(:owner) { user }
            let(:key) { 'metrics_dashboard.create' }

            before {
              post_create(md_params)
            }

            include_examples'correct public activity'
          end
        end
      end

      context 'with incorrect params' do
        it 'does not save the new group' do
          expect{ post_create() }
            .to_not change(MetricsDashboard, :count)
        end

        it 'renders new view' do
          post_create
          expect(response).to render_template :new
        end

        it "flashes an alert message" do
          post_create
          expect(flash[:alert]).to eq "Your dashboard was not created. Please fix the errors"
        end

        it 'shows error' do
          post_create
          metrics_dashboard = assigns(:metrics_dashboard)

          expect(metrics_dashboard.errors).to_not be_empty
        end
      end
    end

    context 'without logged in user' do
      before { post_create }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'GET #show' do
    def get_show
      get :show, :id => metrics_dashboard.id
    end

    context 'with logged user' do
      login_user_from_let

      before {
        metrics_dashboard.shareable_token #Touch token, so it is initialized
        get_show
      }

       it "returns set metrics dashboard" do
        expect(assigns[:metrics_dashboard]).to eq metrics_dashboard
      end

      it "render show template" do
        expect(response).to render_template :show
      end

      it 'sets correct shareable token', focus: true do
        expect(assigns[:token]).to eq metrics_dashboard.shareable_token
      end
    end

    context 'without logged user' do
      before { get_show }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'GET #edit' do
    def get_edit
      get :edit, :id => metrics_dashboard.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit }

      it "render edit template" do
        expect(response).to render_template :edit
      end
    end

    context 'without logged user' do
      before { get_edit }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'PATCH #update' do
    def patch_update( id = -1, params = {})
      patch :update, id: id, metrics_dashboard: params
    end

    let(:user) { create :user }
    let!(:metrics_dashboard) { create :metrics_dashboard, enterprise: user.enterprise, owner: user }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        let(:new_md_params) { attributes_for :metrics_dashboard }

        it 'updates fields' do
          patch_update(metrics_dashboard.id, new_md_params)
          updated_md = MetricsDashboard.find(metrics_dashboard.id)

          expect(updated_md.name).to eq new_md_params[:name]
          expect(updated_md.enterprise).to eq user.enterprise
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              patch_update(metrics_dashboard.id, new_md_params)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { MetricsDashboard.last }
            let(:owner) { user }
            let(:key) { 'metrics_dashboard.update' }

            before {
              patch_update(metrics_dashboard.id, new_md_params)
            }

            include_examples'correct public activity'
          end
        end

        it 'redirects to correct page' do
          patch_update(metrics_dashboard.id, new_md_params)
          expect(response).to redirect_to action: :index
        end

        it "flashes a notice message" do
          patch_update(metrics_dashboard.id, new_md_params)
          expect(flash[:notice]).to eq "Your dashboard was updated"
        end
      end

      context "incorrect params" do
        login_user_from_let
        let(:invalid_md_params) { { name: "" } }

        it 'redirects to correct page' do
          patch_update(metrics_dashboard.id, invalid_md_params)
          expect(response).to render_template :edit
        end

        it "flashes a notice message" do
          patch_update(metrics_dashboard.id, invalid_md_params)
          expect(flash[:alert]).to eq "Your dashboard was not updated. Please fix the errors"
        end
      end
    end

    context 'without logged in user' do
      before { patch_update(metrics_dashboard.id, name: 'blah') }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'DELETE #destroy' do
    def delete_destroy(id = -1)
      delete :destroy, id: id
    end

    let(:user) { create :user }
    let!(:metrics_dashboard) { create :metrics_dashboard, enterprise: user.enterprise, owner: user }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        it 'deletes initiative' do
          expect{
            delete_destroy(metrics_dashboard.id)
          }.to change(MetricsDashboard, :count).by(-1)
        end

        it 'redirects to correct action' do
          delete_destroy(metrics_dashboard.id)
          expect(response).to redirect_to  action: :index
        end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                delete_destroy(metrics_dashboard.id)
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { MetricsDashboard.last }
              let(:owner) { user }
              let(:key) { 'metrics_dashboard.destroy' }

              before {
                delete_destroy(metrics_dashboard.id)
              }

              include_examples'correct public activity'
            end
          end
      end
    end

    context 'without logged in user' do
      it 'return error' do
        delete_destroy(metrics_dashboard.id)
        expect(response).to_not be_success
      end

      it 'do not change count' do
        expect {
          delete_destroy(metrics_dashboard.id)
        }.to_not change(MetricsDashboard, :count)
      end

      context "redirect unlogged in user" do
        before { delete_destroy(metrics_dashboard.id) }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end
end
