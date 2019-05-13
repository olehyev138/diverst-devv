require 'rails_helper'

RSpec.describe Initiatives::UpdatesController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:initiative) { initiative_of_group(group) }
  let(:initiative_update) { create :initiative_update, initiative: initiative, report_date: Time.now + 1.days }

  describe 'GET#index' do
    describe 'when user is logged in' do
      login_user_from_let

      let(:initiative_update2) { create :initiative_update, initiative: initiative, report_date: Time.now + 2.days }
      before { get :index, group_id: group.id, initiative_id: initiative.id }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'returns updates in order of descending by report_date' do
        expect(assigns[:updates]).to eq [initiative_update2, initiative_update]
      end
    end

    describe 'when user is not logged in' do
      before { get :index, group_id: group.id, initiative_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    login_user_from_let

    it 'edits an update' do
      get :edit, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id
      expect(response).to be_success
    end
  end

  describe 'GET#new' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :new, group_id: group.id, initiative_id: initiative.id }

      it 'renders new template' do
        expect(response).to render_template :new
      end

      it 'returns a new update object' do
        expect(assigns[:update]).to be_a_new(InitiativeUpdate)
      end
    end

    describe 'when user is not logged in' do
      before { get :new, group_id: group.id, initiative_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :show, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id }

      it 'renders show template' do
        expect(response).to render_template :show
      end

      it 'returns a valid update object' do
        expect(assigns[:update]).to be_valid
      end
    end

    describe 'when user is not logged in' do
      before { get :show, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'when user is logged in' do
      context 'with valid params' do
        login_user_from_let

        it 'redirects' do
          post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: { report_date: Date.today }
          expect(response).to redirect_to action: :index
        end

        it 'creates the initiative_update' do
          expect { post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: { report_date: Date.today } }
          .to change(InitiativeUpdate, :count).by(1)
        end

        it 'flashes' do
          post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: { report_date: Date.today }
          expect(flash[:notice]).to eq('Your initiative update was created')
        end

        it 'sets the owner' do
          post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: { report_date: Date.today }
          expect(InitiativeUpdate.last.owner).to eq(user)
        end
      end

      context 'when unsuccessful' do
        login_user_from_let

        before {
          allow_any_instance_of(InitiativeUpdate).to receive(:save).and_return(false)
          post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: { report_date: Date.today }
        }

        it 'renders new' do
          expect(response).to render_template :new
        end

        it 'does not create the initiative_update' do
          expect(InitiativeUpdate.count).to eq(0)
        end

        it 'flashes' do
          expect(flash[:alert]).to eq('Your initiative update was not created. Please fix the errors')
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, group_id: group.id, initiative_id: initiative.id, initiative_update: { report_date: Date.today } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let
      context 'when successful' do
        before { patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id, initiative_update: { report_date: Date.today } }

        it 'redirects' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the initiative_update' do
          initiative_update.reload
          expect(initiative_update.report_date).to eq(Date.today)
        end

        it 'flashes' do
          expect(flash[:notice]).to eq('Your initiative update was updated')
        end
      end

      context 'when unsuccessful' do
        before {
          allow_any_instance_of(InitiativeUpdate).to receive(:update).and_return(false)
          patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id, initiative_update: { report_date: Date.today }
        }

        it 'renders edit' do
          expect(response).to render_template :edit
        end

        it 'flashes' do
          expect(flash[:alert]).to eq('Your initiative update was not updated. Please fix the errors')
        end
      end
    end

    describe 'when user is not logged in' do
      before { patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id, initiative_update: { report_date: Date.today } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      it 'redirects' do
        delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id
        expect(response).to redirect_to action: :index
      end

      it 'deletes the initiative_update' do
        expect { delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id }
        .to change(InitiativeUpdate.where(id: initiative_update.id), :count).by(-1)
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_update.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
