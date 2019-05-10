require 'rails_helper'

RSpec.describe Initiatives::ResourcesController, type: :controller, skip: 'THIS CODE IS NOT EVEN USED' do
  let(:enterprise) { create(:enterprise) }
  let(:initiative) { build(:initiative) }
  let(:pillar) { create(:pillar, initiatives: [initiative]) }
  let(:outcome) { create(:outcome, pillars: [pillar]) }
  let(:group) { create(:group, enterprise: enterprise, outcomes: [outcome]) }
  let(:user) { create(:user, groups: [group], enterprise: enterprise) }

  describe 'GET#index' do
    context 'with logged user' do
      login_user_from_let
      let!(:resource) { create(:resource, initiative: initiative) }
      let!(:another_resource) { create(:resource) }

      before { get :index, group_id: group.id, initiative_id: initiative.id }


      it 'return all resources of a initiative of a group of user' do
        expect(assigns(:resources)).to eq [resource]
      end

      it 'render index template' do
        expect(response).to render_template :index
      end
    end

    context 'with a user not logged in' do
      before { get :index, group_id: group.id, initiative_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'with logged user' do
      login_user_from_let
      before { get :new, group_id: group.id, initiative_id: initiative.id }

      it 'assigns a new Resource to @resource' do
        expect(assigns(:resource)).to be_a_new(Resource)
      end

      it 'renders new template' do
        expect(response).to render_template :new
      end
    end

    context 'with a user not logged in' do
      before { get :new, group_id: group.id, initiative_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    let!(:resource) { create(:resource, initiative: initiative) }

    describe 'with logged user' do
      login_user_from_let

      context 'and id is valid' do
        it 'and valid attributes creates a new Resource' do
          expect {
            post :create, group_id: group.id, initiative_id: initiative.id, resource: attributes_for(:resource)
          }.to change(Resource.where(initiative: initiative), :count).by(1)
        end

        it 'redirects to action index' do
          post :create, group_id: group.id, initiative_id: initiative.id, resource: attributes_for(:resource)
          expect(response).to redirect_to(action: :index)
        end
      end

      context 'with invalid attributes' do
        it "doesn't create a new Resource" do
          invalid_attributes = attributes_for(:resource)
          invalid_attributes[:title] = nil

          expect { post :create, group_id: group.id, initiative_id: initiative.id, resource: invalid_attributes }.to change(Resource.where(initiative: initiative), :count).by(0)
        end

        it 'renders edit template' do
          invalid_attributes = attributes_for(:resource)
          invalid_attributes[:title] = nil
          post :create, group_id: group.id, initiative_id: initiative.id, id: resource.id,
                        resource: invalid_attributes

          expect(response).to render_template :edit
        end
      end
    end

    describe 'with a user not logged in' do
      before { post :create, group_id: group.id, initiative_id: initiative.id, id: resource.id,
                             resource: attributes_for(:resource)
      }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    context 'with logged user' do
      login_user_from_let

      it 'and id is valid then assign the searched Resource to @resource' do
        post :create, group_id: group.id, initiative_id: initiative.id,
                      resource: { file: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/verizon_logo.png', 'image/png'), title: Faker::Lorem.sentence(3) }
        resource = Resource.last
        get :show, group_id: group.id, initiative_id: initiative.id, id: resource.id
        expect(response.stream.to_path).to eq resource.file.path
      end

      it 'and id is invalid then raises RecordNotFound exception' do
        bypass_rescue
        expect { get :show, group_id: group.id, initiative_id: initiative.id, id: 0 }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a user not logged in' do
      let!(:resource) { create(:resource, initiative: initiative) }
      before { get :show, group_id: group.id, initiative_id: initiative.id, id: resource.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    let(:resource) { create(:resource, initiative: initiative) }

    context 'with logged user' do
      login_user_from_let

      it 'and id is valid then assign the searched Resource to @resource' do
        get :edit, group_id: group.id, initiative_id: initiative.id, id: resource.id
        expect(assigns(:resource)).to be_valid
      end

      it 'renders edit template' do
        get :edit, group_id: group.id, initiative_id: initiative.id, id: resource.id
        expect(response).to render_template :edit
      end

      it 'and id is invalid then raises RecordNotFound exception' do
        bypass_rescue
        expect { get :edit, group_id: group.id, initiative_id: initiative.id, id: 0 }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'without a logged in user' do
      before { get :edit, group_id: group.id, initiative_id: initiative.id, id: resource.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    let(:resource) { create(:resource, title: 'Resource', initiative: initiative) }

    describe 'with logged user' do
      login_user_from_let

      context 'and id is valid' do
        it 'and valid attributes then updates the Resource' do
          patch :update, group_id: group.id, initiative_id: initiative.id, id: resource.id,
                         resource: attributes_for(:resource, title: 'Resource 2')
          resource.reload
          expect(resource.title).to eq 'Resource 2'
        end

        it 'redirects to action index' do
          patch :update, group_id: group.id, initiative_id: initiative.id, id: resource.id,
                         resource: attributes_for(:resource, title: 'Resource 2')
          expect(response).to redirect_to action: :index
        end
      end

      context 'with invalid attributes' do
        it 'then raises RecordNotFound exception when id is invalid' do
          bypass_rescue
          expect { patch :update, group_id: group.id, initiative_id: initiative.id, id: 0 }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'renders edit template' do
          patch :update, group_id: group.id, initiative_id: initiative.id, id: resource.id,
                         resource: attributes_for(:resource, title: nil)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, group_id: group.id, initiative_id: initiative.id, id: resource.id,
                              resource: attributes_for(:resource, title: 'Resource 2')
      }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    let(:resource) { create(:resource, initiative: initiative) }

    context 'with logged user' do
      login_user_from_let

      it 'and id is valid then destroy the Resource' do
        expect { delete :destroy, group_id: group.id, initiative_id: initiative.id, id: resource.id }.to change(Resource.where(id: resource), :count).by(-1)
      end

      it 'redirect to action index' do
        delete :destroy, group_id: group.id, initiative_id: initiative.id, id: resource.id
        expect(response).to redirect_to(action: :index)
      end

      it 'and id is invalid then raises RecordNotFound exception' do
        bypass_rescue
        expect { delete :destroy, group_id: group.id, initiative_id: initiative.id, id: 0 }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'without a logged in user' do
      before { delete :destroy, group_id: group.id, initiative_id: initiative.id, id: resource.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
