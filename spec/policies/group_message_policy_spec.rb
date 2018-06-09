require 'rails_helper'

RSpec.describe GroupMessagePolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :group_messages_manage => false, :group_messages_index => false, :group_messages_create => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:group_message){ create(:group_message, :owner => user)}
    
    subject { described_class }

    permissions :index?, :create?, :update?, :destroy? do
        it "allows access" do
            expect(subject).to permit(user, group_message)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, group_message)
        end
    end
end
