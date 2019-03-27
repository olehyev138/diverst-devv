require 'rails_helper'

RSpec.describe MetricsDashboardsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create :enterprise }
  let!(:user) { create :user, :enterprise => enterprise }
  let!(:user2) { create :user, enterprise: enterprise }
  let(:metrics_dashboard) { create :metrics_dashboard, :enterprise => enterprise, owner: user }

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

      before do
        metrics_dashboard
        create_list(:group, 2, enterprise: user.enterprise)
        create_list(:segment, 3, enterprise: user.enterprise)
        create_list(:resource, 4, enterprise: user.enterprise)
        folder = create(:folder, enterprise: user.enterprise)
        create_list(:resource, 4, folder: folder)
        create_list(:poll, 2, enterprise: user.enterprise)
        get_index
      end

      it 'returns correct data for general_metrics' do
        expect(assigns[:general_metrics])
        .to eq ({:nb_users=>2, :nb_ergs=>2, :nb_segments=>3, :nb_resources=>4, :nb_polls=>2, :nb_ongoing_campaigns=>0, :average_nb_members_per_group=>nil})
      end

      it "return metrics" do
        expect(assigns[:dashboards]).to eq [metrics_dashboard]
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

    describe 'with logged in user' do
      let(:md_params) { attributes_for :metrics_dashboard, enterprise: user.enterprise, group_ids: [create(:group).id], shared_user_ids: [user2.id] }

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
          expect(response).to redirect_to new_metrics_dashboard_graph_path(MetricsDashboard.last)
        end

        it 'creates correct dashboard' do
          post_create(md_params)

          new_md = MetricsDashboard.last

          expect(new_md.enterprise).to eq user.enterprise
          expect(new_md.name).to eq md_params[:name]
        end

        it 'redirects to correct action' do
          post_create(md_params)
          expect(response).to redirect_to new_metrics_dashboard_graph_path(MetricsDashboard.last)
        end

        it 'creates shared dashboard' do
          post_create(md_params)

          new_md = MetricsDashboard.last
          new_sd = SharedMetricsDashboard.last

          expect(new_sd.metrics_dashboard_id).to eq new_md.id
          expect(new_sd.user_id).to eq user2.id
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{
                post_create(md_params)
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { MetricsDashboard.last }
            let(:owner) { user }
            let(:key) { 'metrics_dashboard.create' }

            before {
              perform_enqueued_jobs do
                post_create(md_params)
              end
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

    describe 'without logged in user' do
      before { post_create }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'GET #show' do
    def get_show
      get :show, :id => metrics_dashboard.id
    end

    context 'with logged user' do
      context "with valid token" do
        login_user_from_let

        before do
          create_list(:graph_with_metrics_dashboard, 2, metrics_dashboard: metrics_dashboard)
          metrics_dashboard.shareable_token #Touch token, so it is initialized
          get_show
        end

         it "returns set metrics dashboard" do
          expect(assigns[:metrics_dashboard]).to eq metrics_dashboard
        end

        it "render show template" do
          expect(response).to render_template :show
        end

        it 'sets correct shareable token' do
          expect(assigns[:token]).to eq metrics_dashboard.shareable_token
        end

        it 'return 2 graphs objects that belong to metrics_dashboard object' do
          expect(assigns[:graphs].count).to eq 2
          expect(assigns[:graphs]).to eq metrics_dashboard.graphs.includes(:field, :aggregation)
        end
      end

      context "with no token" do
        login_user_from_let

        before do
          metrics_dashboard.shareable_token = nil
          metrics_dashboard.save!
          metrics_dashboard.groups.destroy_all
          get_show
        end

        it "render edit template" do
          expect(response).to render_template :edit
        end
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
    let!(:metrics_dashboard) { create :metrics_dashboard, enterprise: user.enterprise, owner: user, shared_user_ids: [user2.id] }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        let(:new_md_params) { attributes_for :metrics_dashboard, owner: user, shared_user_ids: [] }

        it 'updates fields' do
          patch_update(metrics_dashboard.id, new_md_params)
          updated_md = MetricsDashboard.find(metrics_dashboard.id)

          expect(updated_md.name).to eq new_md_params[:name]
          expect(updated_md.enterprise).to eq user.enterprise
        end

        it 'updates shared dashboards' do
          patch_update(metrics_dashboard.id, new_md_params)

          expect(SharedMetricsDashboard.find_by(metrics_dashboard_id: metrics_dashboard.id)).to eq nil
          expect(SharedMetricsDashboard.find_by(user_id: user2.id)).to eq nil
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              perform_enqueued_jobs do
                patch_update(metrics_dashboard.id, new_md_params)
              end
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { MetricsDashboard.last }
            let(:owner) { user }
            let(:key) { 'metrics_dashboard.update' }

            before {
              perform_enqueued_jobs do
                patch_update(metrics_dashboard.id, new_md_params)
              end
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
        it 'deletes metrics dashboard' do
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
                perform_enqueued_jobs do
                  delete_destroy(metrics_dashboard.id)
                end
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { MetricsDashboard.last }
              let(:owner) { user }
              let(:key) { 'metrics_dashboard.destroy' }

              before {
                perform_enqueued_jobs do
                  delete_destroy(metrics_dashboard.id)
                end
              }

              include_examples'correct public activity'
            end
          end
      end
    end

    context 'with shared dashboard user' do
      let(:owner_user) { create :user }
      let!(:user) { create :user, enterprise: owner_user.enterprise }
      let!(:metrics_dashboard) { create :metrics_dashboard, enterprise: owner_user.enterprise, owner: owner_user, shared_user_ids: [user.id] }
      login_user_from_let

      it 'doesnt destroy main dashboard' do
        expect {
          delete_destroy(metrics_dashboard.id)
        }.to_not change(MetricsDashboard, :count)
      end

      it 'only destroys shared dashboard' do
        expect {
          delete_destroy(metrics_dashboard.id)
        }.to change(SharedMetricsDashboard, :count).by(-1)
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
