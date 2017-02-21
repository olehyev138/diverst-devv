require 'rails_helper'

RSpec.describe MetricsDashboardsController, type: :controller do
  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      login_user

      before { get_index }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_index }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end



  describe 'POST #create' do
    def post_create(params={a: 1})
      post :create, metrics_dashboard: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      let(:md_params) { attributes_for :metrics_dashboard, enterprise: user.enterprise }

      login_user_from_let

      context 'with correct params' do
        it 'creates metrics dashboard' do
          expect{
            post_create(md_params)
          }.to change(MetricsDashboard, :count).by(1)
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

        it 'shows error' do
          post_create
          metrics_dashboard = assigns(:metrics_dashboard)

          expect(metrics_dashboard.errors).to_not be_empty
        end
      end
    end

    context 'without logged in user' do
      before { post_create }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end
end
