require 'rails_helper'

RSpec.describe NewsLinkPolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :news_links_index => false, :news_links_create => false, :news_links_manage => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:group) { create :group, enterprise: user.enterprise }
    let(:news_link) { create(:news_link, group: group) }

    subject { described_class }
    
    permissions :index?, :create?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, news_link)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, news_link)
        end
    end
end
