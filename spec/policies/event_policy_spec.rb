require 'rails_helper'

RSpec.describe EventPolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :events_index => false, :events_create => false, :events_manage => false )}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:event){ create(:event)}
    
    subject { described_class }

    permissions :create?, :update?, :destroy? do
        it "allows access" do
            expect(subject).to permit(user, event)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, event)
        end
    end
end
