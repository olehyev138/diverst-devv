require 'rails_helper'

RSpec.describe GroupMessagePolicy, :type => :policy do
    
    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
    let!(:group_message){ create(:group_message, :owner => user)}
    
    subject { described_class }
    
    before {
        no_access.policy_group.group_messages_index = false
        no_access.policy_group.group_messages_create = false
        no_access.policy_group.group_messages_manage = false
        no_access.policy_group.save!
    }

    permissions :index?, :create?, :update?, :destroy? do
        it "allows access" do
            expect(subject).to permit(user, group_message)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, group_message)
        end
    end
end
