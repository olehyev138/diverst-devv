require 'rails_helper'

RSpec.describe Groups::FoldersController, type: :controller do
  let(:enterprise) { create(:enterprise, name: 'test') }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:user_group) { create(:user_group, group: group, user: user) }
  let!(:folder) { create(:folder, group: group, enterprise_id: nil, password_protected: true, password: 'password') }

  describe 'POST#authenticate' do
    login_user_from_let
    context 'valid params' do
      before { post :authenticate, id: folder.id, group_id: group.id, folder: { password: 'password' } }

      it 'redirects' do
        expect(response).to redirect_to [group, folder, :resources]
      end
    end

    context 'invalid params' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        post :authenticate, id: folder.id, group_id: group.id, folder: { password: 'folder' }
      end

      it 'redirect_to index' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes an alert message' do
        expect(flash[:alert]).to eq 'Invalid Password'
      end
    end
  end

  describe 'GET#index' do
    describe 'when user is logged in' do
      context 'when current_user is an active member of group' do
        login_user_from_let
        before do
          user_group
          get :index, group_id: group.id
        end


        it 'render index template' do
          expect(response).to render_template :index
        end

        it 'assigns the folders' do
          expect(assigns[:folders]).to eq([folder])
        end
      end

      context 'when current_user is not an active member of group' do
        let(:other_user) { create(:user) }
        let(:other_group) { create(:group, enterprise: other_user.enterprise) }

        before do
          sign_in(other_user)
          get :index, group_id: other_group.id
        end

        it 'returns empty folder' do
          expect(assigns[:folders]).to eq []
        end

        it 'render index template' do
          expect(response).to render_template :index
        end
      end
    end

    describe 'when user is not logged in' do
      before { get :index, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    context 'with user logged in' do
      login_user_from_let
      before { xhr :get, :show, group_id: group.id, id: folder.id, format: :js }

      it 'set a valid folder object' do
        expect(assigns[:folder]).to be_valid
      end

      it 'set valid group object' do
        expect(assigns[:group]).to eq group
        expect(assigns[:group]).to be_valid
      end

      it 'returns success' do
        expect(response).to be_success
      end

      it 'render show template' do
        expect(response).to render_template :show
      end
    end

    describe 'when user is not logged in' do
      before { xhr :get, :show, group_id: group.id, id: folder.id, format: :js }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :new, group_id: group.id, folder_id: folder.id }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it 'assigns new folder' do
        expect(assigns[:folder]).to be_a_new(Folder)
      end

      it 'assigns a parent_id' do
        expect(assigns[:folder].parent_id).to eq(folder.id)
      end
    end

    describe 'when user is not logged in' do
      before { get :new, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, id: folder.id, group_id: group.id }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it 'returns a valid folder object' do
        expect(assigns[:folder]).to be_valid
      end
    end

    describe 'when user is not logged in' do
      before { get :edit, id: folder.id, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        it 'redirect_to index' do
          post :create, group_id: group.id, folder: { name: 'folder' }
          expect(response).to redirect_to action: :index
        end

        it 'creates the folder' do
          expect { post :create, group_id: group.id, folder: { name: 'folder' } }
          .to change(Folder, :count).by(1)
        end
      end

      context 'valid params for nested' do
        it "redirect_to folder's resources" do
          post :create, group_id: group.id, folder: { name: 'folder', parent_id: folder.id }
          expect(response).to redirect_to [group, folder, :resources]
        end

        it 'creates the folder' do
          expect { post :create, group_id: group.id, folder: { name: 'folder' } }
          .to change(Folder, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'returns edit' do
          post :create, group_id: group.id, folder: { name: nil }
          expect(response).to render_template(:edit)
        end

        it "doesn't create the folder" do
          expect { post :create, group_id: group.id, folder: { name: nil } }
          .to change(Folder, :count).by(0)
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, group_id: group.id, folder: { name: 'folder' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        before do
          patch :update, group_id: group.id, id: folder.id, folder: { name: 'updated' }
        end

        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the folder' do
          folder.reload
          expect(folder.name).to eq('updated')
        end
      end

      context 'invalid params' do
        before { patch :update, group_id: group.id, id: folder.id, folder: { name: nil } }

        it 'returns edit' do
          expect(response).to render_template(:edit)
        end

        it "doesn't update the folder" do
          folder.reload
          expect(folder.name).to_not be(nil)
        end
      end
    end

    describe 'when user is not logged in' do
      before { patch :update, group_id: group.id, id: folder.id, folder: { name: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let
      before { delete :destroy, id: folder.id, group_id: group.id }

      it 'returns success' do
        expect(response).to redirect_to action: :index
      end

      it 'deletes the folder' do
        expect(Folder.where(id: folder.id).count).to eq(0)
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, id: folder.id, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
