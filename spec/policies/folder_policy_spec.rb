require 'rails_helper'

RSpec.describe FolderPolicy, :type => :policy do
    
    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
    let(:folder){ create(:folder, :container => enterprise)}

    subject { described_class }
    
    before {
        no_access.policy_group.enterprise_resources_index = false
        no_access.policy_group.enterprise_resources_create = false 
        no_access.policy_group.enterprise_resources_manage = false
        no_access.policy_group.save!
    }
    
    permissions :index?, :create? , :update?, :edit?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, folder)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, folder)
        end
    end
end
