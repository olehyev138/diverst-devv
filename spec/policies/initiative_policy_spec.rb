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
    
    permissions :index?, :create?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, initiative)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, initiative)
        end
    end
    
    permissions :show? do
        let!(:policy_group_2){ create(:policy_group, :name => "TEST", :initiatives_manage => false)}
        let!(:enterprise_2) {create(:enterprise, :policy_groups => [policy_group_2])}
        let!(:user_2){ create(:user, :enterprise => enterprise_2, :policy_group => policy_group_2) }
    
        it "does not allow access" do
            expect(subject).to_not permit(user_2, initiative)
        end
        
        it "allows access when user is member of group" do
            group = initiative.group
            create(:user_group, :user => user_2, :group => group)
            expect(subject).to permit(user_2, initiative)
        end
        
        it "allows access when user is member of participating group" do
            participating_group = create(:group, :enterprise => enterprise_2)
            create(:user_group, :user => user_2, :group => participating_group)
            initiative.participating_groups << participating_group
            expect(subject).to permit(user_2, initiative)
        end
        
        it "allows access when initiatives_manage is true" do
            policy_group_2.initiatives_manage = true
            policy_group_2.save!
            expect(subject).to permit(user_2, initiative)
        end
        
        it "allows access when user is erg leader" do
            allow(user_2).to receive(:erg_leader?).and_return(true)
            expect(subject).to permit(user_2, initiative)
        end
    end
end
