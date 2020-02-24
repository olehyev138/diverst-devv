require 'rails_helper'

RSpec.describe AdminViewHelper do
  describe '#active_manage_erg_link' do
    context 'returns true' do
      it 'when params[:controller] is groups/resources' do
        params[:controller] = 'groups/resources'
        expect(active_manage_erg_link?).to eq true
      end

      it 'when params[:controller] is enterprises/resources' do
        params[:controller] = 'enterprises/resources'
        expect(active_manage_erg_link?).to eq true
      end

      it 'when controller_name is groups and action_name includes any of "calendar, index, import_csv, edit, new"' do
        allow(self).to receive(:controller).and_return(GroupsController)
        allow(self).to receive(:action_name).and_return('calendar')
        expect(active_manage_erg_link?).to eq true
      end

      it 'when controller_name is enterprises and action_name includes resources' do
        allow(self).to receive(:controller).and_return(EnterprisesController)
        allow(self).to receive(:action_name).and_return('resources')
        expect(active_manage_erg_link?).to eq true
      end
    end

    describe '#active_engage_link?' do
      context 'returns true' do
        it 'when controller_name is either expenses, expense_categories or campaigns' do
          allow(self).to receive(:controller).and_return(ExpensesController)
          expect(active_engage_link?).to eq true
        end
      end
    end

    describe '#active_plan_link?' do
      context 'returns true' do
        it 'when controller_name is groups and action_name is close_budgets' do
          allow(self).to receive(:controller).and_return(GroupsController)
          allow(self).to receive(:action_name).and_return('close_budgets')
          expect(active_plan_link?).to eq true
        end
      end
    end

    describe '#active_global_settings_link?' do
      context 'returns true' do
        it 'when controller_name is enterprises and action_name includes either
				edit_auth, edit_field, edit_budgeting, or edit_posts' do
          allow(self).to receive(:controller).and_return(EnterprisesController)
          allow(self).to receive(:action_name).and_return('edit_auth')
          expect(active_global_settings_link?).to eq true
        end

        it 'when controller_name is users' do
          allow(self).to receive(:controller).and_return(UsersController)
          expect(active_global_settings_link?).to eq true
        end
      end
    end

    describe '#show_settings_link?' do
      let!(:user) { create(:user) }
      before do
        allow(helper).to receive(:current_user).and_return(user)
      end

      context 'returns true' do
        it 'when .sso_manage?, .manage_permissions? or .manage_branding? for EnteprisePolicy is true' do
          expect(helper.show_settings_link?).to eq true
        end
      end

      it 'returns false' do
        user.policy_group = create(:policy_group, :no_permissions)
        expect(helper.show_settings_link?).to eq false
      end
    end

    describe '#show_diversity_link?' do
      let!(:user) { create(:user) }
      before do
        allow(helper).to receive(:current_user).and_return(user)
      end

      context 'returns true' do
        it 'when .diversity_manage? for  EnteprisePolicy is true' do
          expect(helper.show_diversity_link?).to eq true
        end

        it 'when .manage_all_groups? for GroupPolicy and EnteprisePolicy is true' do
          expect(helper.show_diversity_link?).to eq true
        end
      end

      it 'returns false' do
        user.policy_group = create(:policy_group, :no_permissions)
        expect(helper.show_diversity_link?).to eq false
      end
    end
  end
end
