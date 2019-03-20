require 'rails_helper'

RSpec.describe GenericGraphsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, active: true) }
  let!(:field) { create(:field, type: "NumericField", enterprise: enterprise, elasticsearch_only: false) }
  let!(:group) {create(:group, :enterprise => enterprise, :parent_id => nil)}
  let!(:child) {create(:group, :enterprise => enterprise, :parent_id => group.id)}
  let!(:user_group) {create(:user_group, :accepted_member => true, :user => user, :group => group )}
  let!(:segment_1) {create(:segment, :enterprise => enterprise)}
  let!(:segment_2) {create(:segment, :enterprise => enterprise)}
  let!(:segmentation) {create(:segmentation, :parent => segment_1, :child => segment_2)}

  describe "GET#group_population" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :group_population, format: :json

          g = 'UserGroup'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq "#{c_t(:erg).capitalize} Population"
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsGroupPopulationDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :group_population, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsGroupPopulationDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :group_population, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :group_population, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :group_population, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#segment_population" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :segment_population, format: :json

          g = 'UsersSegment'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq "#{c_t(:segment).capitalize} Population"
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsSegmentPopulationDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :segment_population, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsSegmentPopulationDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :segment_population, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :segment_population, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :segment_population, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#events_created" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :events_created, format: :json

          g = 'Initiative'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq 'Events Created'
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsEventsCreatedDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :events_created, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsEventsCreatedDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :events_created, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :events_created, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :events_created, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#messages_sent" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :messages_sent, format: :json

          g = 'GroupMessage'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq 'Messages Sent'
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsMessagesSentDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :messages_sent, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsMessagesSentDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :messages_sent, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :messages_sent, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :messages_sent, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#mentorship" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :mentorship, format: :json

          g = 'UserGroup'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq 'Users interested in Mentorship'
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsMentorshipDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :mentorship, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsMentorshipDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :mentorship, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :mentorship, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :mentorship, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#mentoring_sessions" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :mentoring_sessions, format: :json

          g = 'MentoringSession'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq 'Mentoring Sessions'
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsMentoringSessionsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :mentoring_sessions, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsMentoringSessionsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :mentoring_sessions, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :mentoring_sessions, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :mentoring_sessions, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#mentoring_interests" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :mentoring_interests, format: :json

          g = 'MentoringInterest'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq 'Mentoring Interests'
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsMentoringInterestsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :mentoring_interests, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsMentoringInterestsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :mentoring_interests, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :mentoring_interests, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :mentoring_interests, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#top_groups_by_views" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :top_groups_by_views, format: :json

          g = 'View'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq "# Views per #{c_t(:erg).capitalize}"
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsTopGroupsByViewsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :top_groups_by_views, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsTopGroupsByViewsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :top_groups_by_views, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :top_groups_by_views, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :top_groups_by_views, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#top_folders_by_views" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :top_folders_by_views, format: :json

          g = 'View'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq "# Views per Folder"
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsTopFoldersByViewsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :top_folders_by_views, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsTopFoldersByViewsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :top_folders_by_views, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :top_folders_by_views, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :top_folders_by_views, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#top_resources_by_views" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :top_resources_by_views, format: :json

          g = 'View'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq "# Views per Resource"
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsTopResourcesByViewsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :top_resources_by_views, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsTopResourcesByViewsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :top_resources_by_views, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :top_resources_by_views, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :top_resources_by_views, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end

  describe "GET#top_news_by_views" do
    describe "with logged in user" do
      login_user_from_let

      context "when format is json" do
        before {
          get :top_news_by_views, format: :json

          g = 'View'
          g = g.constantize
          g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
          g.__elasticsearch__.create_index!
        }

        it "returns json format" do
          expect(response.content_type).to eq "application/json"
        end

        it "returns success" do
          expect(response).to be_success
        end

        context 'returns the correct json data' do
          let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

          it 'returns correct title' do
            expect(json_response[:title]).to eq "# Views per News Link"
          end
        end
      end

      context "when format is csv" do
        before {
          allow(GenericGraphsTopNewsByViewsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = "back"
          get :top_news_by_views, format: :csv
        }

        it "returns to previous page" do
          expect(response).to redirect_to "back"
        end

        it "flashes" do
          expect(flash[:notice]).to eq "Please check your Secure Downloads section in a couple of minutes"
        end

        it "calls job" do
          expect(GenericGraphsTopNewsByViewsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect{ get :top_news_by_views, format: :csv }.to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    describe "without a logged in user" do
      context "when format is json" do
        before { get :top_news_by_views, format: :json }
        it_behaves_like "redirect user to users/sign_in path"
      end

      context "when format is json" do
        before { get :top_news_by_views, format: :csv }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end
end
