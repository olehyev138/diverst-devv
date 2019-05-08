require 'rails_helper'

RSpec.describe Groups::Folder::ResourcesController, type: :controller do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: user.enterprise) }
  let!(:user_group) { create(:user_group, group: group, user: user) }
  let!(:folder) { create(:folder, group: group, enterprise: nil) }
  let!(:resource) { create(:resource, title: 'title', enterprise: nil, folder: folder, file: fixture_file_upload('files/test.csv', 'text/csv')) }

  describe 'GET#index' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :index, folder_id: folder.id, group_id: group.id }

      it 'renders index template' do
        expect(response).to render_template :index
      end

      it 'sets a valid group object belonging to enterprise' do
        expect(assigns[:group].enterprise).to eq enterprise
        expect(assigns[:group]).to be_valid
      end

      it 'sets a valid group object' do
        expect(assigns[:group]).to eq group
        expect(assigns[:group]).to be_valid
      end

      it 'returns resources that belong to container' do
        expect(assigns[:resources].where(folder_id: assigns[:container].id)).to eq [resource]
      end

      it "increments the folder's total_views" do
        expect(folder.total_views).to eq(1)
      end
    end

    context 'without logged user' do
      before { get :index, folder_id: folder.id, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :new, folder_id: folder.id, group_id: group.id }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it 'assigns new resource' do
        expect(assigns[:resource]).to be_a_new(Resource)
      end
    end

    context 'without logged user' do
      before { get :new, folder_id: folder.id, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, id: resource.id, folder_id: folder.id, group_id: group.id }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it 'sets a valid group object' do
        expect(assigns[:group]).to eq group
        expect(assigns[:group]).to be_valid
      end

      it 'sets a valid resource object' do
        expect(assigns[:resource]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :edit, id: resource.id, folder_id: folder.id, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        it 'redirect_to index' do
          post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource', file: file }
          expect(response).to redirect_to action: :index
        end

        it 'creates the resouce' do
          expect { post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource', file: file } }
          .to change(Resource, :count).by(1)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource', file: file } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Resource.last }
            let(:owner) { user }
            let(:key) { 'resource.create' }

            before {
              perform_enqueued_jobs do
                post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource', file: file }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'invalid params' do
        it 'returns edit' do
          post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource' }
          expect(response).to render_template(:edit)
        end

        it "doesn't create the resource" do
          expect { post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource' } }
          .to change(Resource, :count).by(0)
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, group_id: group.id, folder_id: folder.id, resource: { title: 'resource', file: file } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    context 'user is logged in' do
      login_user_from_let
      before { get :show, id: resource.id, folder_id: folder.id, group_id: group.id }

      it 'returns file in csv format' do
        expect(response.content_type).to eq 'text/csv'
      end

      it "filename should be 'test.csv'" do
        expect(response.headers['Content-Disposition']).to include 'test.csv'
      end
    end

    context 'when user is not logged in' do
      before { get :show, id: resource.id, folder_id: folder.id, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        before do
          patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: { title: 'updated', file: file }
        end

        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the resource' do
          resource.reload
          expect(resource.title).to eq('updated')
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: { title: 'updated', file: file } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { resource }
            let(:owner) { user }
            let(:key) { 'resource.update' }

            before {
              perform_enqueued_jobs do
                patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: { title: 'updated', file: file }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'invalid params' do
        before { patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: { title: nil, file: nil } }

        it 'returns edit' do
          expect(response).to render_template(:edit)
        end

        it "doesn't update the resouce" do
          resource.reload
          expect(resource.title).to_not be(nil)
        end
      end
    end

    describe 'when user is not logged in' do
      before do
        patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: { title: 'updated', file: file }
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      it 'redirects to index action' do
        delete :destroy, id: resource.id, group_id: group.id, folder_id: folder.id
        expect(response).to redirect_to action: :index
      end

      it 'deletes the resource' do
        expect { delete :destroy, id: resource.id, group_id: group.id, folder_id: folder.id }
        .to change(Resource, :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :destroy, id: resource.id, group_id: group.id, folder_id: folder.id }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { resource }
          let(:owner) { user }
          let(:key) { 'resource.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: resource.id, group_id: group.id, folder_id: folder.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, id: resource.id, group_id: group.id, folder_id: folder.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#archive' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        before { patch :archive, group_id: group.id, folder_id: resource.folder.id, id: resource.id }

        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end

        it 'archives the resource' do
          expect(assigns[:resource].archived_at).to_not be_nil
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :archive, group_id: group.id, folder_id: resource.folder.id, id: resource.id
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Resource.last }
            let(:owner) { user }
            let(:key) { 'resource.archive' }

            before {
              perform_enqueued_jobs do
                patch :archive, group_id: group.id, folder_id: resource.folder.id, id: resource.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
    end
  end

  describe 'PATCH#restore' do
    describe 'when user is logged in' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        resource.update(archived_at: DateTime.now)
      end

      login_user_from_let

      context 'valid params' do
        before { patch :restore, group_id: group.id, folder_id: resource.folder.id, id: resource.id }

        it 'redirects back' do
          expect(response).to redirect_to 'back'
        end

        it 'restores archived resource' do
          resource.reload
          expect(resource.archived_at).to be_nil
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :restore, group_id: group.id, folder_id: resource.folder.id, id: resource.id
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Resource.last }
            let(:owner) { user }
            let(:key) { 'resource.restore' }

            before {
              perform_enqueued_jobs do
                patch :restore, group_id: group.id, folder_id: resource.folder.id, id: resource.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
    end
  end
end
