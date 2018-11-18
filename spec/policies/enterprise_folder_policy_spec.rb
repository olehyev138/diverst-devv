require 'rails_helper'

RSpec.describe EnterpriseFolderPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:folder){ create(:folder, :enterprise => enterprise)}

  subject { described_class }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_resources_index = false
    no_access.policy_group.enterprise_resources_create = false
    no_access.policy_group.enterprise_resources_manage = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  context "when manage_all is false" do
    it "ensure manage_all is false" do
      expect(user.policy_group.manage_all).to be(false)
    end

    permissions :index?, :create? , :update?, :edit?, :update?, :destroy? do

      it "allows access" do
        expect(subject).to permit(user, folder)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, folder)
      end
    end
  end

  context "when manage_all is true" do
    before {
      user.policy_group.manage_all = true
      user.policy_group.enterprise_resources_index = false
      user.policy_group.enterprise_resources_create = false
      user.policy_group.enterprise_resources_manage = false
      user.policy_group.save!
    }

    it "ensure manage_all is true" do
      expect(user.policy_group.manage_all).to be(true)
    end

    permissions :index?, :create? , :update?, :edit?, :update?, :destroy? do

      it "allows access" do
        expect(subject).to permit(user, folder)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, folder)
      end
    end
  end
end
