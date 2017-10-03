require 'rails_helper'

RSpec.describe InitiativePolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :initiatives_index => false, :initiatives_create => false, :initiatives_manage => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:group) { create :group, enterprise: user.enterprise }
    let(:outcome) {create :outcome, group_id: group.id}
    let(:pillar) { create :pillar, outcome_id: outcome.id}
    let(:initiative) { create :initiative, pillar: pillar, owner_group: group}

    subject { described_class }
    
    permissions :index?, :show?, :create?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, initiative)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, initiative)
        end
    end
end
