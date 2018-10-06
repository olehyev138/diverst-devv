require 'rails_helper'

RSpec.describe InitiativePolicy, :type => :policy do
    
    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
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
            no_access.policy_group.initiatives_index = false
            no_access.policy_group.initiatives_create = false
            no_access.policy_group.initiatives_manage = false
            no_access.policy_group.save!
            expect(subject).to_not permit(no_access, initiative)
        end
    end
    
    permissions :show? do
        let!(:user_2){ create(:user) }
    
        it "does not allow access" do
            user_2.policy_group.initiatives_index = false
            user_2.policy_group.initiatives_create = false
            user_2.policy_group.initiatives_manage = false
            user_2.policy_group.save!
            expect(subject).to_not permit(user_2, initiative)
        end
        
        it "allows access when user is member of group" do
            group = initiative.group
            create(:user_group, :user => user_2, :group => group)
            expect(subject).to permit(user_2, initiative)
        end
        
        it "allows access when user is member of participating group" do
            participating_group = create(:group, :enterprise => user_2.enterprise)
            create(:user_group, :user => user_2, :group => participating_group)
            initiative.participating_groups << participating_group
            expect(subject).to permit(user_2, initiative)
        end
        
        it "allows access when initiatives_manage is true" do
            user_2.policy_group.initiatives_manage = true
            user_2.policy_group.save!
            expect(subject).to permit(user_2, initiative)
        end
        
        it "allows access when user is erg leader" do
            allow(user_2).to receive(:erg_leader?).and_return(true)
            expect(subject).to permit(user_2, initiative)
        end
    end
end
