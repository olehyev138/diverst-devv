require 'rails_helper'

RSpec.describe Initiatives::ResourcesController, type: :controller do
  let(:enterprise){ create(:enterprise) }
  let(:initiative){ build(:initiative) }
  let(:pillar){ create(:pillar, initiatives: [initiative]) }
  let(:outcome){ create(:outcome, pillars: [pillar]) }
  let(:group){ create(:group, enterprise: enterprise, outcomes: [outcome]) }
  let(:user){ create(:user, groups: [group], enterprise: enterprise) }

  describe "GET#index" do
    context "with logged user" do
      login_user_from_let
      let!(:resource){ create(:resource, container_type: "Initiative", container_id: initiative.id) }
      let!(:another_resource){ create(:resource) }

      it "return all resources of a initiative of a group of user" do
        get :index, group_id: group.id, initiative_id: initiative.id
        expect(assigns(:resources)).to eq [resource]
      end
    end
  end

  describe "GET#new" do
    context "with logged user" do
      login_user_from_let

      it "assigns a new Resource to @resource" do
        get :new, group_id: group.id, initiative_id: initiative.id
        expect(assigns(:resource)).to be_an_instance_of(Resource)
      end
    end
  end

  describe "POST#create" do
    context "with logged user" do
      login_user_from_let
      let(:resource){ create(:resource, container_type: "Initiative", container_id: initiative.id) }

      context "and id is valid" do
        it "and valid attributes creates a new Resource" do
          expect{ post :create, group_id: group.id, initiative_id: initiative.id, id: resource.id,
            resource: attributes_for(:resource) }.to change(Resource.where(container_type: "Initiative"), :count).by(1)
        end
      end
    end
  end

  describe "GET#show" do
    context "with logged user" do
      login_user_from_let
      let(:resource){ create(:resource_with_file, container_type: "Initiative", container_id: initiative.id) }

      xit "and id is valid then assign the searched Resource to @resource" do
        get :show, group_id: group.id, initiative_id: initiative.id, id: resource.id
        expect(response.stream.to_path).to eq resource.file.path
      end

      it "and id is invalid then raises RecordNotFound exception" do
        bypass_rescue
        expect{ get :show, group_id: group.id, initiative_id: initiative.id, id: 0 }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET#edit" do
    context "with logged user" do
      login_user_from_let
      let(:resource){ create(:resource, container_type: "Initiative", container_id: initiative.id) }

      it "and id is valid then assign the searched Resource to @resource" do
        get :edit, group_id: group.id, initiative_id: initiative.id, id: resource.id
        expect(assigns(:resource)).to eq resource
      end

      it "and id is invalid then raises RecordNotFound exception" do
        bypass_rescue
        expect{ get :edit, group_id: group.id, initiative_id: initiative.id, id: 0 }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "PATCH#update" do
    context "with logged user" do
      login_user_from_let
      let(:resource){ create(:resource, title: "Resource", container_type: "Initiative", container_id: initiative.id) }

      context "and id is valid" do
        it "and valid attributes then updates the Resource" do
          patch :update, group_id: group.id, initiative_id: initiative.id, id: resource.id,
            resource: attributes_for(:resource, title: "Resource 2")
          resource.reload
          expect(resource.title).to eq "Resource 2"
        end
      end

      context "and id is invalid" do
        it "then raises RecordNotFound exception" do
          bypass_rescue
          expect{ patch :update, group_id: group.id, initiative_id: initiative.id, id: 0 }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "DELET#destroy" do
    context "with logged user" do
      login_user_from_let
      let(:resource){ create(:resource, container_type: "Initiative", container_id: initiative.id) }

      it "and id is valid then destroy the Resource" do
        expect{ delete :destroy, group_id: group.id, initiative_id: initiative.id, id: resource.id }
          .to change(Resource.where(id: resource), :count).by(-1)
      end

      it "and id is invalid then raises RecordNotFound exception" do
        bypass_rescue
        expect{ delete :destroy, group_id: group.id, initiative_id: initiative.id, id: 0 }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
