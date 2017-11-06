require 'rails_helper'

RSpec.describe FolderPolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :enterprise_resources_index => false, :enterprise_resources_create => false, :enterprise_resources_manage => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:folder){ create(:folder, :container => enterprise)}

    subject { described_class }
    
    permissions :index?, :create? , :update?, :edit?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, folder)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, folder)
        end
    end
end
