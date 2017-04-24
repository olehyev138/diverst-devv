require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      login_user

      before { get_index }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_index }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #settings' do
    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise }

    def get_settings(group_id = -1)
      get :settings, id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_settings(group.id) }

      context 'with incorrect group' do
      end

      context 'with group user can\'t manage' do
      end

      context 'with group user can manage' do
        let(:group) { create :group, enterprise: user.enterprise, owner: user }

        it 'return success' do
          expect(response).to be_success
        end
      end
    end

    context 'without logged user' do
      before { get_settings }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #create' do
    def post_create(params={a: 1})
      post :create, group: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      let(:group_attrs) { attributes_for :group }

      login_user_from_let

      context 'with correct params' do
        it 'creates group' do
          expect{
            post_create(group_attrs)
          }.to change(Group, :count).by(1)
        end

        it 'creates correct group' do
          post_create(group_attrs)

          new_group = Group.last

          expect(new_group.enterprise).to eq user.enterprise
          expect(new_group.name).to eq group_attrs[:name]
          expect(new_group.created_at).to be_within(100).of Time.now.in_time_zone
          expect(new_group.owner).to eq user
        end

        it 'redirects to correct action' do
          post_create(group_attrs)
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              post_create(group_attrs)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.create' }

            before {
              post_create(group_attrs)
            }

            include_examples'correct public activity'
          end
        end
      end

      context 'with incorrect params' do
        it 'does not save the new group' do
          expect{ post_create() }
            .to_not change(Group, :count)
        end

        it 'renders new view' do
          post_create
          expect(response).to render_template :new
        end

        it 'shows error' do
          post_create
          group = assigns(:group)

          expect(group.errors).to_not be_empty
        end
      end
    end

    context 'without logged in user' do
      before { post_create }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'PATCH #update' do
    def patch_update( group_id = -1, params = {})
      patch :update, id: group_id, group: params
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    before { set_referrer }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        let(:group_attrs) { attributes_for :group }

        it 'updates fields' do
          patch_update(group.id, group_attrs)

          updated_group = Group.find(group.id)

          expect(updated_group.name).to eq group_attrs[:name]
          expect(updated_group.description).to eq group_attrs[:description]
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              patch_update(group.id, group_attrs)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.update' }

            before {
              patch_update(group.id, group_attrs)
            }

            include_examples'correct public activity'
          end
        end

        it 'redirects to correct page' do
          patch_update(group.id, group_attrs)

          expect(response).to redirect_to default_referrer
        end
      end

      context 'with incorrect params' do
        before { patch_update(group.id, { name: '' }) }

        it 'does not update indsitiative' do
          updated_group = Group.find(group.id)

          expect(updated_group.name).to eq group.name
          expect(updated_group.description).to eq group.description
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'without logged in user' do
      before { patch_update(group.id) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_destroy(group_id = -1)
      delete :destroy, id: group_id
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        it 'deletes initiative' do
          expect{
            delete_destroy(group.id)
          }.to change(Group, :count).by(-1)
        end

        it 'redirects to correct action' do
          delete_destroy(group.id)

          expect(response).to redirect_to  action: :index
        end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                delete_destroy(group.id)
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Group.last }
              let(:owner) { user }
              let(:key) { 'group.destroy' }

              before {
                delete_destroy(group.id)
              }

              include_examples'correct public activity'
            end
          end
      end
    end

    context 'without logged in user' do
      it 'return error' do
        delete_destroy(group.id)
        expect(response).to_not be_success
      end

      it 'do not change Group count' do
        expect {
          delete_destroy(group.id)
        }.to_not change(Group, :count)
      end
    end
  end

  describe 'GET#plan_overview' do
    def get_plan_overview
      get :plan_overview
    end

    context 'with logged user' do
      let!(:foreign_group) { FactoryGirl.create :group }

      login_user_from_let

      before { get_plan_overview }

      it 'return success' do
        expect(response).to be_success
      end

      it 'shows groups from correct enterprise' do
        groups = assigns(:groups)

        expect(groups).to include group
        expect(groups).to_not include foreign_group
      end
    end

    context 'without logged user' do
      before { get_plan_overview }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end
end
