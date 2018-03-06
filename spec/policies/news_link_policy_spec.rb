require 'rails_helper'

RSpec.describe NewsLinkPolicy, :type => :policy do
    
    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
    let(:group) { create :group, enterprise: user.enterprise }
    let(:news_link) { create(:news_link, group: group) }

    subject { described_class }
    
    before {
        no_access.policy_group.news_links_index = false
        no_access.policy_group.news_links_create = false
        no_access.policy_group.news_links_manage = false
        no_access.policy_group.save!
    }
    
    permissions :index?, :create?, :update?, :destroy? do
                  
        it "allows access" do
            expect(subject).to permit(user, news_link)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, news_link)
        end
    end
end
