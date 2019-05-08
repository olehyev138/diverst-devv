require 'rails_helper'

RSpec.describe Groups::UpdatesController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:group_update) { create(:group_update, group: group) }

  describe 'GET#index' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :index, group_id: group.id }

      it 'set a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'returns group.dates' do
        expect(assigns[:updates]).to eq [group_update]
      end

      it 'render index template' do
        expect(response).to render_template :index
      end
    end

    describe 'when user is not logged in' do
      before { get :index, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :new, group_id: group.id }

      it 'returns a new group update object' do
        expect(assigns[:update]).to be_a_new(GroupUpdate)
      end

      it 'render new template' do
        expect(response).to render_template :new
      end
    end

    describe 'when user is not logged in' do
      before { get :new, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :show, group_id: group.id, id: group_update.id }

      it 'sets a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'returns a valid group update object' do
        expect(assigns[:update]).to eq group_update
      end

      it 'render show template' do
        expect(response).to render_template :show
      end
    end

    describe 'when user is not logged in' do
      before { get :new, group_id: group.id, id: group_update.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :edit, group_id: group.id, id: group_update.id }

      it 'sets a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'returns a valid group update object' do
        expect(assigns[:update]).to eq group_update
      end

      it 'render edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'when user is not logged in' do
      before { get :edit, group_id: group.id, id: group_update.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'with logged user' do
      login_user_from_let
      let(:group) { create(:group, enterprise: user.enterprise) }

      context 'with valid params' do
        let(:group_update) { attributes_for(:group_update) }

        it 'creates a new group_update' do
          expect { post :create, group_id: group.id, group_update: group_update }.to change(GroupUpdate.where(owner_id: user.id, group: group), :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, group_id: group.id, group_update: group_update
          expect(flash[:notice]).to eq 'Your group update was created'
        end

        it 'redirects to index action' do
          post :create, group_id: group.id, group_update: group_update
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, group_id: group.id, group_update: group_update }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { GroupUpdate.last }
            let(:owner) { user }
            let(:key) { 'group_update.create' }

            before {
              perform_enqueued_jobs do
                post :create, group_id: group.id, group_update: group_update
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid params' do
        let(:group_update) { attributes_for(:group_update, created_at: nil) }

        it 'does not create a new group_update' do
          expect { post :create, group_id: group.id, group_update: group_update }.to change(GroupUpdate, :count).by(0)
        end

        it 'flashes an alert message' do
          post :create, group_id: group.id, group_update: group_update
          expect(flash[:alert]).to eq 'Your group update was not created. Please fix the errors'
        end

        it 'renders the new action' do
          post :create, group_id: group.id, group_update: group_update
          expect(response).to render_template :new
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, group_id: group.id, group_update: group_update }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    describe 'when user is logged in' do
      login_user_from_let
      let(:destroy) { delete :destroy, group_id: group.id, id: group_update.id }

      it 'redirects' do
        destroy
        expect(response).to redirect_to action: :index
      end

      it 'deletes the group update' do
        destroy
        expect(GroupUpdate.where(id: group_update.id).count).to eq(0)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { destroy }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group_update }
          let(:owner) { user }
          let(:key) { 'group_update.destroy' }

          before {
            perform_enqueued_jobs do
              destroy
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    describe 'when user is not logged in' do
      before { delete :destroy, group_id: group.id, id: group_update.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'with logged user' do
      login_user_from_let
      let(:group) { create(:group, enterprise: user.enterprise) }
      let(:group_update) { create(:group_update, group: group, created_at: '2017-01-02') }

      context 'with valid params' do
        before do
          patch :update, group_id: group.id, id: group_update.id, group_update: { created_at: '2017-01-01' }
        end

        it 'updates the group_update' do
          group_update.reload
          expect(group_update.created_at).to eq Date.parse('2017-01-01')
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your group update was updated'
        end

        it 'redirects to index action' do
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, group_id: group.id, id: group_update.id, group_update: { created_at: '2017-01-01' } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { group_update }
            let(:owner) { user }
            let(:key) { 'group_update.update' }

            before {
              perform_enqueued_jobs do
                patch :update, group_id: group.id, id: group_update.id, group_update: { created_at: '2017-01-01' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid params' do
        before do
          patch :update, group_id: group.id, id: group_update.id, group_update: { created_at: '' }
        end

        it 'does not update the group_update' do
          expect(group_update.created_at.strftime('%Y-%m-%d')).to eq '2017-01-02'
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your group update was not updated. Please fix the errors'
        end

        it 'renders the edit action' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'when user is not logged in' do
      before { patch :update, group_id: group.id, id: group_update.id, group_update: { created_at: '2017-01-01' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
