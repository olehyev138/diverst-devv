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

  describe 'POST #create' do
  end

  describe 'POST #update' do
  end

  describe 'DELETE #destroy' do
  end
end
