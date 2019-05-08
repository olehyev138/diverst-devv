require 'rails_helper'

RSpec.describe Enterprises::ResourcesController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let!(:admin_resource) { create(:resource, title: 'title', enterprise: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: 'admin') }
  let!(:national_resource) { create(:resource, title: 'title', enterprise: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: 'national') }

  describe 'GET#index' do
    context 'when user is logged' do
      login_user_from_let
      before { get :index, enterprise_id: enterprise.id }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'assigns the admin_resources' do
        expect(assigns[:admin_resources]).to eq([admin_resource])
      end

      it 'assigns the national_resources' do
        expect(assigns[:national_resources]).to eq([national_resource])
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
      before { get :new, enterprise_id: enterprise.id, resource_type: 'admin' }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it 'assigns new resource' do
        expect(assigns[:resource]).to be_a_new(Resource)
      end

      it 'sets resource_type' do
        expect(assigns[:resource].resource_type).to eq('admin')
      end
    end

    context 'when user is not logged in' do
      before { get :new, enterprise_id: enterprise.id, resource_type: 'admin' }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, id: admin_resource.id, enterprise_id: enterprise.id }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it 'sets a valid enterprise object' do
        expect(assigns[:container]).to be_valid
      end
    end

    context 'when user is not logged in' do
      before { get :edit, id: admin_resource.id, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        it 'redirect_to index' do
          post :create, enterprise_id: enterprise.id, resource: { title: 'resource', file: file }
          expect(response).to redirect_to action: :index
        end

        it 'creates the resource' do
          expect { post :create, enterprise_id: enterprise.id, resource: { title: 'resource', file: file } }
          .to change(Resource, :count).by(1)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, enterprise_id: enterprise.id, resource: { title: 'resource', file: file } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Resource.last }
            let(:owner) { user }
            let(:key) { 'resource.create' }

            before {
              perform_enqueued_jobs do
                post :create, enterprise_id: enterprise.id, resource: { title: 'resource', file: file }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'invalid params' do
        it 'render edit template' do
          post :create, enterprise_id: enterprise.id, resource: { title: 'resource' }
          expect(response).to render_template(:edit)
        end

        it "doesn't create the resource" do
          expect { post :create, enterprise_id: enterprise.id, resource: { title: 'resource' } }
          .to change(Resource, :count).by(0)
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, enterprise_id: enterprise.id, resource: { title: 'resource' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :show, id: admin_resource.id, enterprise_id: enterprise.id }

      it 'returns data in csv format' do
        expect(response.content_type).to eq 'text/csv'
      end

      it "filename should be 'test.csv'" do
        expect(response.headers['Content-Disposition']).to include 'test.csv'
      end
    end

    context 'when user is not logged in' do
      before { get :show, id: admin_resource.id, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

    describe 'when user is logged in' do
      login_user_from_let

      context 'valid params' do
        before do
          patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: { title: 'updated', file: file }
        end

        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the resource' do
          admin_resource.reload
          expect(admin_resource.title).to eq('updated')
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: { title: 'updated', file: file } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { admin_resource }
            let(:owner) { user }
            let(:key) { 'resource.update' }

            before {
              perform_enqueued_jobs do
                patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: { title: 'updated', file: file }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'invalid params' do
        before { patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: { title: nil, file: nil } }

        it 'returns edit' do
          expect(response).to render_template(:edit)
        end

        it "doesn't update the resource" do
          admin_resource.reload
          expect(admin_resource.title).to_not be(nil)
        end
      end
    end

    describe 'when user is not logged in' do
      before do
        patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: { title: 'updated', file: file }
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      it 'redirect to index action' do
        delete :destroy, id: admin_resource.id, enterprise_id: enterprise.id
        expect(response).to redirect_to action: :index
      end

      it 'deletes the resources' do
        expect { delete :destroy, id: admin_resource.id, enterprise_id: enterprise.id }
        .to change(Resource.where(id: admin_resource.id), :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :destroy, id: admin_resource.id, enterprise_id: enterprise.id }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { admin_resource }
          let(:owner) { user }
          let(:key) { 'resource.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: admin_resource.id, enterprise_id: enterprise.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, id: admin_resource.id, enterprise_id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#archived' do
    context 'when user is logged' do
      let!(:archived_resource) { create(:resource, folder: create(:folder, enterprise: enterprise), enterprise: enterprise, archived_at: DateTime.now) }
      login_user_from_let
      before { get :archived, enterprise_id: enterprise.id }

      it 'render archived template' do
        expect(response).to render_template :archived
      end

      it 'returns one archived resource' do
        expect(assigns[:resources].count).to eq 1
      end
    end
  end

  describe 'POST#restore_all' do
    let!(:archived_resources) { create_list(:resource, 2, enterprise: enterprise, folder: create(:folder, enterprise: enterprise),
                                                          archived_at: DateTime.now)
    }

    context 'when user restores all resources' do
      login_user_from_let
      before { request.env['HTTP_REFERER'] = 'back' }

      it 'redirects back' do
        post :restore_all, enterprise_id: enterprise.id
        expect(response).to redirect_to 'back'
      end

      it 'restore all archived resources' do
        expect { post :restore_all, enterprise_id: enterprise.id }.to change(Resource.unarchived_resources(enterprise.folder_ids, []), :count).by(-2)
      end
    end
  end

  describe 'POST#delete_all' do
    let!(:archived_resources) { create_list(:resource, 2, enterprise: enterprise, folder: create(:folder, enterprise: enterprise),
                                                          archived_at: DateTime.now)
    }

    context 'when user deletes all resources' do
      login_user_from_let
      before { request.env['HTTP_REFERER'] = 'back' }

      it 'redirects back' do
        post :delete_all, enterprise_id: enterprise.id
        expect(response).to redirect_to 'back'
      end

      it 'deletes all archived resources' do
        expect { post :delete_all, enterprise_id: enterprise.id }.to change(Resource.where.not(archived_at: nil), :count).by(-2)
      end
    end
  end
end
