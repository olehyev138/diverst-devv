require 'rails_helper'

RSpec.describe EventPolicy, :type => :policy do

    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
    let(:event){ create(:event)}
    
    subject { described_class }
    
    before {
        no_access.policy_group.events_index = false
        no_access.policy_group.events_create = false
        no_access.policy_group.events_manage = false
        no_access.policy_group.save!
    }

    permissions :create?, :update?, :destroy?, :index? do
        it "allows access" do
            expect(subject).to permit(user, event)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, event)
        end
    end
end
