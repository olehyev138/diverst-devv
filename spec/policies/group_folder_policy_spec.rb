require 'rails_helper'

RSpec.describe GroupFolderPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:folder){ create(:folder, :enterprise => enterprise)}

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.group_resources_index = false
    no_access.policy_group.group_resources_create = false
    no_access.policy_group.group_resources_manage = false
    no_access.policy_group.save!
  }

  context "when manage_all is false" do
    it "ensure manage_all is false" do
      expect(user.policy_group.manage_all).to be(false)
    end

    context "user has groups_manage true" do
      permissions :index? do
        it "allows access" do
          expect(subject).to permit(user, [group, nil])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :create? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :edit? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :update? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :destroy? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end
    end

    context "user has groups_manage false and is a group leader" do
      before {
        create(:user_group, :user => user, :group => group)
        create(:group_leader, :group => group, :user => user, :user_role => enterprise.user_roles.where(:role_type => "group").first)
        user.policy_group.groups_manage = false
        user.policy_group.save!
      }

      permissions :index? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :create? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :edit? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :update? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :destroy? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end
    end

    context "user has groups_manage false and is a group member" do
      before {
        create(:user_group, :user => user, :group => group)
        user.policy_group.groups_manage = false
        user.policy_group.save!
      }

      permissions :index? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :create? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :edit? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :update? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :destroy? do
        it "allows access" do
          expect(subject).to permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end
    end

    context "user has groups_manage false and is not an admin or group leader or member" do
      before {
        user.policy_group.groups_manage = false
        user.policy_group.save!
      }

      permissions :index? do
        it "doesn't allow access" do
          expect(subject).to_not permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :create? do
        it "doesn't allow access" do
          expect(subject).to_not permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :edit? do
        it "doesn't allow access" do
          expect(subject).to_not permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :update? do
        it "doesn't allow access" do
          expect(subject).to_not permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end

      permissions :destroy? do
        it "doesn't allow access" do
          expect(subject).to_not permit(user, [group])
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, [group])
        end
      end
    end
  end

  context "when manage_all is true" do
    before {
      user.policy_group.manage_all = true
      user.policy_group.group_resources_index = false
      user.policy_group.group_resources_create = false
      user.policy_group.group_resources_manage = false
      user.policy_group.save!
    }

    it "ensure manage_all is true" do
      expect(user.policy_group.manage_all).to be(true)
    end

    permissions :index? do
      it "allows access" do
        expect(subject).to permit(user, [group])
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, [group])
      end
    end

    permissions :create? do
      it "allows access" do
        expect(subject).to permit(user, [group])
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, [group])
      end
    end

    permissions :edit? do
      it "allows access" do
        expect(subject).to permit(user, [group])
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, [group])
      end
    end

    permissions :update? do
      it "allows access" do
        expect(subject).to permit(user, [group])
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, [group])
      end
    end

    permissions :destroy? do
      it "allows access" do
        expect(subject).to permit(user, [group])
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, [group])
      end
    end
  end
end
