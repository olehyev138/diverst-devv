require 'rails_helper'

RSpec.describe EnterprisePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }

  subject { EnterprisePolicy.new(user, enterprise) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_manage = false
    no_access.policy_group.sso_manage = false
    no_access.policy_group.diversity_manage = false
    no_access.policy_group.branding_manage = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      before { user.policy_group.update manage_all: false }

      it 'ensure manage_all is false' do 
        expect(user.policy_group.manage_all).to be(false)
      end

      context 'allows access to actions' do 
        it { is_expected.to permit_actions([:update, :edit_auth, :edit_fields, :edit_mobile_fields, 
           :manage_posts, :diversity_manage, :update_branding, 
           :edit_pending_comments, :restore_default_branding]) 
            }
      end

      context 'when manage_all is true' do 
        before {
          user.policy_group.manage_all = true
          user.policy_group.enterprise_manage = false
          user.policy_group.sso_manage = false
          user.policy_group.diversity_manage = false
          user.policy_group.branding_manage = false
          user.policy_group.manage_posts = false
          user.policy_group.save!
        }

        it "ensure manage_all is true" do
          expect(user.policy_group.manage_all).to be(true)
        end

        context 'allows access to actions' do 
          it { is_expected.to permit_actions([:update, :edit_auth, :edit_fields, :edit_mobile_fields, 
             :manage_posts, :diversity_manage, :update_branding, 
             :edit_pending_comments, :restore_default_branding]) 
             }
        end
      end
    end
  end

  describe 'users with no access' do 
    let!(:user) { no_access }

    context 'allows access to actions' do 
      it { is_expected.to forbid_actions([:update, :edit_auth, :edit_fields, :edit_mobile_fields, 
         :manage_posts, :diversity_manage, :update_branding, 
         :edit_pending_comments, :restore_default_branding]) 
          }
    end
  end
end
