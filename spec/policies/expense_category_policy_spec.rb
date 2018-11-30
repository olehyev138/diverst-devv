require 'rails_helper'

RSpec.describe ExpenseCategoryPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:expense_category) { create(:expense_category) }

  subject { described_class }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.campaigns_manage = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  context "when manage_all is false" do
    it "ensure manage_all is false" do
      expect(user.policy_group.manage_all).to be(false)
    end

    permissions :index? do
      context "when subject campaigns_index is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end

      context "when subject campaigns_index is false but campaigns_manage is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_index = false
          user.policy_group.save!

          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :new? do
      context "when subject campaigns_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end

      context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_create = false
          user.policy_group.save!

          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :create? do
      context "when subject campaigns_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end

      context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_create = false
          user.policy_group.save!

          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :update? do
      context "when subject campaigns_manage is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :destroy? do
      context "when subject campaigns_manage is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end
  end

  context "when manage_all is true" do
    before {
      user.policy_group.manage_all = true
      user.policy_group.campaigns_manage = false
      user.policy_group.save!
    }
    it "ensure manage_all is true" do
      expect(user.policy_group.manage_all).to be(true)
    end

    permissions :index? do
      context "when subject campaigns_index is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end

      context "when subject campaigns_index is false but campaigns_manage is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_index = false
          user.policy_group.save!

          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :new? do
      context "when subject campaigns_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end

      context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_create = false
          user.policy_group.save!

          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :create? do
      context "when subject campaigns_create is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end

      context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
        it "allows access" do

          user.policy_group.campaigns_create = false
          user.policy_group.save!

          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :update? do
      context "when subject campaigns_manage is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end

    permissions :destroy? do
      context "when subject campaigns_manage is true for user and false for no_access" do
        it "allows access" do
          expect(subject).to permit(user, expense_category)
        end

        it "doesn't allow access" do
          expect(subject).to_not permit(no_access, expense_category)
        end
      end
    end
  end
end
