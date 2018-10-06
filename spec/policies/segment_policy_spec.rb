require 'rails_helper'

RSpec.describe SegmentPolicy, :type => :policy do

    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:enterprise_2) {create(:enterprise, :scope_module_enabled => false)}
    let(:no_access) { create(:user, :enterprise => enterprise_2) }
    let(:segment){ create(:segment, enterprise: enterprise) }
    
    subject { described_class }

    permissions :index?, :create?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, segment)
        end

        it "doesn't allow access" do
            no_access.policy_group.segments_index = false
            no_access.policy_group.segments_create = false
            no_access.policy_group.segments_manage = false
            no_access.policy_group.save!
            expect(subject).to_not permit(no_access, segment)
        end
    end
end
