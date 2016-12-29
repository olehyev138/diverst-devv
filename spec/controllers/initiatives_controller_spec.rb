require 'rails_helper'

RSpec.describe InitiativesController, type: :controller do
  let(:user) { create :user }
  let!(:group) { create :group, enterprise: user.enterprise }

  describe 'GET #index' do
    def get_index(group_id = -1)
      get :index, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_index(group.id) }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_index(group.id) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #new' do
    def get_new(group_id = -1)
      get :new, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_new(group.id) }

      it 'return success' do
        expect(response).to be_success
      end

      it 'assigns new group' do
        new_initiative = assigns(:initiative)

        expect(new_initiative).to be_new_record
      end
    end

    context 'without logged user' do
      before { get_new(group.id) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #show' do
    it 'does not have a route'
  end

  describe 'GET #edit' do
    let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }

    let!(:initiative) { create :initiative, owner_group: group }

    #TODO this is bad. We need to associate group with initiatives directly
    before { group.outcomes.first.pillars.first.initiatives << initiative }

    def get_edit(group_id = -1, initiative_id = -1)
      get :edit, group_id: group_id, id: initiative_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit(group.id, initiative.id) }

      it 'return success' do
        expect(response).to be_success
      end

      it 'sets initiative' do
        assigned_initiative = assigns(:initiative)

        expect(assigned_initiative).to eq initiative
      end
    end

    context 'without logged user' do
      before { get_edit(group.id, initiative.id) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'non-GET' do
    let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }
    let!(:initiative) { build :initiative, owner_group: group }

    describe 'POST #create' do
      def post_create(group_id = -1, params = {})
        post :create, group_id: group_id, initiative: params
      end

      context 'with logged in user' do
        login_user_from_let

        context 'with correct params' do
          let(:initiative_attrs) { attributes_for :initiative }

          it 'creates initiative' do
            expect{
              post_create(group.id, initiative_attrs)
            }.to change(Initiative, :count).by(1)
          end

          it 'creates correct initiative' do
            post_create(group.id, initiative_attrs)

            new_initiative = Initiative.last

            expect(new_initiative.owner).to eq user
            expect(new_initiative.owner_group).to eq group

            expect(new_initiative.name).to eq initiative_attrs[:name]
            expect(new_initiative.description).to eq initiative_attrs[:description]
            expect(new_initiative.location).to eq initiative_attrs[:location]
            expect(new_initiative.start).to be_within(1).of initiative_attrs[:start]
            expect(new_initiative.end).to be_within(1).of initiative_attrs[:end]
          end

          it 'redirects to correct page' do
            post_create(group.id, initiative_attrs)

            expect(response).to redirect_to action: :index
          end
        end

        context 'with incorrect params' do
          before { post_create(group.id, initiative: {}) }

          it 'returns error' do
            expect(response).to_not be_success
          end
        end
      end

      context 'without logged in user' do
        before { post_create(group.id) }

        it 'return error' do
          expect(response).to_not be_success
        end
      end
    end

    describe 'PATCH #update' do
      def patch_update(group_id = -1, id= -1, params = {})
        patch :update, group_id: group_id, id: id, initiative: params
      end

      let!(:initiative) { create :initiative, owner_group: group }

      context 'with logged in user' do
        login_user_from_let

        context 'with correct params' do
          let(:initiative_attrs) { attributes_for :initiative }

          it 'updates fields' do
            patch_update(group.id, initiative.id, initiative_attrs)

            updated_initiative = Initiative.find(initiative.id)

            expect(updated_initiative.name).to eq initiative_attrs[:name]
            expect(updated_initiative.description).to eq initiative_attrs[:description]
            expect(updated_initiative.location).to eq initiative_attrs[:location]
            expect(updated_initiative.start).to be_within(1).of initiative_attrs[:start]
            expect(updated_initiative.end).to be_within(1).of initiative_attrs[:end]
          end

          it 'redirects to correct page' do
            patch_update(group.id, initiative.id, initiative_attrs)

            expect(response).to redirect_to [group, :initiatives]
          end
        end

        context 'with incorrect params' do
          before { patch_update(group.id, initiative.id, initiative: {}) }

          it 'returns error' do
            expect(response).to_not be_success
          end

          it 'does not update initiative' do
            updated_initiative = Initiative.find(initiative.id)

            expect(updated_initiative.name).to eq initiative.name
            expect(updated_initiative.description).to eq initiative.description
            expect(updated_initiative.location).to eq initiative.location
            expect(updated_initiative.start).to be_within(1).of initiative.start
            expect(updated_initiative.end).to be_within(1).of initiative.end
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
    end
  end
end
