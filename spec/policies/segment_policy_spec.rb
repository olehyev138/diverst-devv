require 'rails_helper'

RSpec.describe SegmentPolicy, :type => :policy do

    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :segments_index => false, :segments_create => false, :segments_manage => false)}
    let(:enterprise_2) {create(:enterprise, :policy_groups => [policy_group], :scope_module_enabled => false)}
    let(:no_access) { create(:user, :enterprise => enterprise_2, :policy_group => policy_group_2) }
    let(:segment){ create(:segment, enterprise: enterprise) }
    
    subject { described_class }

    permissions :index?, :create?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, segment)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, segment)
        end
    end
end
