require 'rails_helper'

RSpec.describe UserPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:enterprise_2) {create(:enterprise)}
  let(:no_access) { create(:user, :enterprise => enterprise_2) }
  let(:policy_scope) { UserPolicy::Scope.new(user, User).resolve }

  subject { described_class }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  permissions ".scope" do
    it "shows only users belonging to enterprise" do
      expect(policy_scope).to eq [user]
    end
  end

  permissions :index? do
    it "allows access when users_index is true" do
      user.policy_group.users_index = true
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to permit(user)
    end

    it "allows access when users_manage is true but users_index is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = true
      user.policy_group.save!

      expect(subject).to permit(user)
    end

    it "doesn't allow access when users_index/manage is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end
  end

  permissions :create? do
    it "doesn't allow access when users_manage is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "doesn't allow access when users_manage is false but users_index is true" do
      user.policy_group.users_index = true
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "allows access when users_manage is true but users_index is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = true
      user.policy_group.save!

      expect(subject).to permit(user)
    end
  end

  permissions :update? do
    it "doesn't allow access when users_manage is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "doesn't allow access when users_manage is false but users_index is true" do
      user.policy_group.users_index = true
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "allows access when users_manage is true but users_index is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = true
      user.policy_group.save!

      expect(subject).to permit(user)
    end
  end

  permissions :destroy? do
    it "doesn't allow access when users_manage is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "doesn't allow access when users_manage is false but users_index is true" do
      user.policy_group.users_index = true
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "allows access when users_manage is true but users_index is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = true
      user.policy_group.save!

      expect(subject).to permit(user)
    end

    it 'allows access user to be deleted if not current user' do
      other_user = create(:user)
      user.policy_group.users_index = false
      user.policy_group.users_manage = true
      user.policy_group.save!

      expect(subject).to permit(user, other_user)
    end
  end

  permissions :resend_invitation? do
    it "doesn't allow access when users_manage is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "doesn't allow access when users_manage is false but users_index is true" do
      user.policy_group.users_index = true
      user.policy_group.users_manage = false
      user.policy_group.save!

      expect(subject).to_not permit(user)
    end

    it "allows access when users_manage is true but users_index is false" do
      user.policy_group.users_index = false
      user.policy_group.users_manage = true
      user.policy_group.save!

      expect(subject).to permit(user)
    end
  end
end
