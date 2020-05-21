require 'rails_helper'

RSpec.describe Enterprises::FoldersController, type: :controller do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let!(:folder) { create(:folder, enterprise: enterprise, password_protected: true, password: 'password') }

  describe 'POST#authenticate' do
    login_user_from_let
    context 'valid params' do
      before { post :authenticate, id: folder.id, enterprise_id: enterprise.id, folder: { password: 'password' } }

      it 'redirects to enterprise_folder_path' do
        expect(response).to redirect_to [enterprise, folder, :resources]
      end
    end

    context 'invalid params' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        post :authenticate, id: folder.id, enterprise_id: enterprise.id, folder: { password: 'folder' }
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
    context 'when user is logged in' do
      let!(:shared_folders) { create_list(:folder_share, 2, enterprise: enterprise, folder: folder) }
      login_user_from_let
      before { get :index, enterprise_id: enterprise.id }

      it 'render template index' do
        expect(response).to render_template :index
      end

      it 'returns 3 folders in total; 1 folder + 2 shared folders' do
        expect(assigns[:enterprise].folders.count).to eq 1
        expect(assigns[:enterprise].shared_folders.count).to eq 2
        expect(assigns[:folders].count).to eq 3
      end

      it 'sets a valid enterprise id' do
        expect(assigns[:enterprise]).to be_valid
        expect(assigns[:enterprise]).to eq enterprise
      end
    end

    context 'when user is not logged in' do
      before { get :index, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :new, enterprise_id: enterprise.id }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it 'assigns new folder' do
        expect(assigns[:folder]).to be_a_new(Folder)
      end

      it 'sets enterprise_id' do
        expect(assigns[:folder].enterprise_id).to eq(enterprise.id)
      end
    end

    context 'when user is not logged in' do
      before { get :new, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, id: folder.id, enterprise_id: enterprise.id }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it 'sets a valid enterprise object which is an Enterprise object' do
        expect(assigns[:enterprise]).to eq enterprise
      end

      it 'sets a valid folder object enterprise_id' do
        expect(assigns[:folder].enterprise_id).to eq enterprise.id
        expect(assigns[:folder]).to be_valid
      end
    end

    context 'when user is logged in' do
      before { get :edit, id: folder.id, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        it 'redirect_to index' do
          post :create, enterprise_id: enterprise.id, folder: { name: 'folder' }
          expect(response).to redirect_to action: :index
        end

        it 'creates the folder' do
          expect { post :create, enterprise_id: enterprise.id, folder: { name: 'folder' } }
          .to change(Folder, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'render edit template' do
          post :create, enterprise_id: enterprise.id, folder: { name: nil }
          expect(response).to render_template(:edit)
        end

        it "doesn't create the folder" do
          expect { post :create, enterprise_id: enterprise.id, folder: { name: nil } }
              .to change(Folder, :count).by(0)
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, enterprise_id: enterprise.id, folder: { name: 'folder' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        before { patch :update, enterprise_id: enterprise.id, id: folder.id, folder: { name: 'updated' } }


        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the folder' do
          folder.reload
          expect(folder.name).to eq('updated')
        end
      end

      context 'invalid params' do
        before { patch :update, enterprise_id: enterprise.id, id: folder.id, folder: { name: nil } }

        it 'render edit template' do
          expect(response).to render_template(:edit)
        end

        it "doesn't update the folder" do
          folder.reload
          expect(folder.name).to_not be(nil)
        end
      end
    end

    describe 'when user is not logged in' do
      before { patch :update, enterprise_id: enterprise.id, id: folder.id, folder: { name: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when users is logged in' do
      login_user_from_let

      it 'redirects to index action' do
        delete :destroy, id: folder.id, enterprise_id: enterprise.id
        expect(response).to redirect_to action: :index
      end

      it 'deletes the folder' do
        expect { delete :destroy, id: folder.id, enterprise_id: enterprise.id }
        .to change(Folder, :count).by(-1)
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, id: folder.id, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
