require 'rails_helper'

RSpec.describe BudgetPolicy, :type => :policy do

    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
    let(:event){ create(:event)}
    
    subject { described_class }
    
    before {
        no_access.policy_group.manage_all = false
        no_access.policy_group.budget_approval = false
        no_access.policy_group.save!
    }
    
    context "when manage_all is false" do
        permissions :approve?, :decline? do
            it "allows access" do
                expect(subject).to permit(user, event)
            end
    
            it "doesn't allow access" do
                expect(subject).to_not permit(no_access, event)
            end
        end
    end
    
    context "when manage_all is true and other permissions are false" do
        before {
            user.policy_group.budget_approval = false
            user.policy_group.manage_all = true
            user.save!
        }
        
        permissions :approve?, :decline? do
            it "allows access" do
                expect(subject).to permit(user, event)
            end
    
            it "doesn't allow access" do
                expect(subject).to_not permit(no_access, event)
            end
        end
    end
end
