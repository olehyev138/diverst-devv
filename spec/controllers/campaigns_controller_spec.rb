require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  let(:enterprise) { create(:enterprise, collaborate_module_enabled: true) }
  let(:user) { create(:user, enterprise: enterprise) }
  let!(:campaign) { create(:campaign, enterprise: enterprise) }


  describe 'GET#index' do
    context 'with logged user' do
      login_user_from_let
      before { get :index }

      it 'returns a list of campaigns' do
        expect(assigns[:campaigns]).to eq [campaign]
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    context 'without logged user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#new' do
    context 'with logged user' do
      login_user_from_let
      before { get :new }

      it 'returns a new campaign object' do
        expect(assigns[:campaign]).to be_a_new(Campaign)
      end

      it 'render new template' do
        expect(response).to render_template :new
      end
    end

    context 'without logged user' do
      before { get :new }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    context 'with logged user' do
      login_user_from_let
      let(:campaign_params) { attributes_for(:campaign) }
      before { campaign_params.merge!({ group_ids: [create(:group).id] }) }


      context 'with correct params' do
        it 'redirects to correct action' do
          post :create, campaign: campaign_params
          expect(response).to redirect_to action: :index
        end

        it 'creates new campaign' do
          expect {
            post :create, campaign: campaign_params
          }.to change(Campaign, :count).by(1)
        end

        it 'it returns a notice flash message' do
          post :create, campaign: campaign_params
          expect(flash[:notice]).to eq 'Your campaign was created'
        end
      end

      context 'with incorrect params' do
        it 'raises an error' do
          bypass_rescue
          expect { post :create, campaign: {} }.to raise_error ActionController::ParameterMissing
        end

        it 'renders new template' do
          post :create, campaign: { title: nil }
          expect(response).to render_template :new
        end

        it 'renders a flash alert' do
          post :create, campaign: { title: nil }
          expect(flash[:alert]).to eq 'Your campaign was not created. Please fix the errors'
        end
      end
    end

    context 'without logged user' do
      let(:campaign_params) { FactoryBot.attributes_for(:campaign) }
      before { post :create, campaign: campaign_params }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#show' do
    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        before { get :show, id: campaign.id }

        it 'get the campaign' do
          expect(assigns[:campaign]).to eq campaign
        end

        it 'returns a list of questions' do
          2.times { create(:question, campaign: campaign) }
          expect(campaign.questions.count).to eq 2
        end

        it 'returns campaign question in desc order by created_at' do
          question1 = create :question, campaign: campaign
          question2 = create :question, campaign: campaign, created_at: 2.minutes.from_now

          expect(assigns[:questions]).to eq [question2, question1]
        end

        it 'returns only 10 questions per page' do
          11.times { create :question, campaign: campaign }
          expect(assigns[:questions].count).to eq 10
        end
      end

      context 'unsuccessfully' do
        it "doesn't get the campaign" do
          bypass_rescue
          expect { get :show, id: -1 }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'without logged user' do
      before { get :show, id: campaign.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#edit' do
    describe 'with logged in user' do
      login_user_from_let

      it 'gets the campaign' do
        get :edit, id: campaign.id
        expect(assigns[:campaign]).to eq campaign
      end

      it 'renders edit template' do
        get :edit, id: campaign.id
        expect(response).to render_template :edit
      end

      it "doesn't get the campaign" do
        bypass_rescue
        expect { get :edit, id: -1 }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end


  describe 'PATCH#update' do
    describe 'with logged in user' do
      context 'successfully' do
        login_user_from_let

        before { patch :update, id: campaign.id, campaign: attributes_for(:campaign, title: 'updated') }

        it 'updates the campaign' do
          campaign.reload
          expect(campaign.title).to eq('updated')
        end

        it 'returns a flash notice message' do
          expect(flash[:notice]).to eq 'Your campaign was updated'
        end

        it 'redirects to index action' do
          expect(response).to redirect_to action: :index
        end
      end

      context 'unsuccessfully' do
        login_user_from_let
        before { patch :update, id: campaign.id, campaign: attributes_for(:campaign, title: nil) }

        it 'renders an alert flash message' do
          expect(flash[:alert]).to eq 'Your campaign was not updated. Please fix the errors'
        end

        it 'renders edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without user logged in' do
      before { patch :update, id: campaign.id, campaign: attributes_for(:campaign, title: 'updated') }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'with logged in user' do
      login_user_from_let

      it 'destroys campaign' do
        expect { delete :destroy, id: campaign.id }.to change(Campaign, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, id: campaign.id
        expect(response).to redirect_to action: :index
      end
    end

    context 'without user logged in' do
      before { delete :destroy, id: campaign.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#contributions_per_erg' do
    context 'with logged in user' do
      login_user_from_let

      it 'gets the contributions_per_erg with json' do
        get :contributions_per_erg, id: campaign.id, format: :json

        expect(response.content_type).to eq 'application/json'
      end

      context 'csv' do
        before {
          allow(CampaignContributionsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :contributions_per_erg, id: campaign.id, format: :csv
        }

        it 'returns to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(CampaignContributionsDownloadJob).to have_received(:perform_later)
        end
      end

      it "doesn't get the contributions_per_erg" do
        bypass_rescue
        expect { get :contributions_per_erg, id: -1 }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'without user logged in' do
      before { delete :destroy, id: campaign.id }

      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#top_performers' do
    context 'with logged in user' do
      login_user_from_let

      it 'gets the top_performers with json' do
        get :top_performers, id: campaign.id, format: :json
        expect(response.content_type).to eq 'application/json'
      end

      context 'csv' do
        before {
          allow(CampaignTopPerformersDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :top_performers, id: campaign.id, format: :csv
        }

        it 'returns to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(CampaignTopPerformersDownloadJob).to have_received(:perform_later)
        end
      end

      it "doesn't get the top_performers" do
        bypass_rescue
        expect { get :top_performers, id: -1 }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'without user logged in' do
      before { get :top_performers, id: campaign.id, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
