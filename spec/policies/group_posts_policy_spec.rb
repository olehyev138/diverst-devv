require 'rails_helper'

RSpec.describe GroupPostsPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:message) { create(:group_message, :owner => user, :group => group) }

  subject { described_class.new(user, [group, message]) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      context 'when group.latest_news_visibility is set to public' do 
        before { group.latest_news_visibility = 'public' }
        
        context 'when ONLY manage_posts is true' do 
          before { user.policy_group.update manage_posts: true , group_posts_index: false }
          
          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end

        context 'when ONLY group_posts_index' do 
          before { user.policy_group.update manage_posts: false , group_posts_index: true }

          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end

        context 'when group_posts_index and manage_posts are false' do 
          before { user.policy_group.update manage_posts: false , group_posts_index: false }

          it 'returns false' do 
            expect(subject.view_latest_news?).to eq false
          end
        end
      end

      context 'when group.latest_news_visibility is set to group' do 
        before { group.latest_news_visibility = 'group' }

        context 'when ONLY manage_posts is true' do 
          before { user.policy_group.update manage_posts: true , group_posts_index: false }
          
          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end

        context 'when ONLY group_posts_index' do 
          before { user.policy_group.update manage_posts: false , group_posts_index: true }

          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end

        context 'when group_posts_index and manage_posts are false' do 
          before { user.policy_group.update manage_posts: false , group_posts_index: false }

          it 'returns false' do 
            expect(subject.view_latest_news?).to eq false
          end
        end
      end

      context 'when group.latest_news_visibility is set to leaders_only' do 
        before { group.latest_news_visibility = 'leaders_only' }

        context 'when user is group manager, with manage_posts set to true' do 
          before { user.policy_group.update groups_manage: true, manage_posts: true, group_posts_index: false }

          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end        

        context 'when user is group manager, with group_posts_index set to true' do 
          before { user.policy_group.update groups_manage: true, manage_posts: false, group_posts_index: true }          
          
          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end

        context 'when user is group manager, but group_posts_index and manage_posts are false' do 
          before { user.policy_group.update groups_manage: true, manage_posts: false, group_posts_index: false }

          it 'returns false' do 
            expect(subject.view_latest_news?).to eq false
          end
        end
      end

      context 'when group.latest_news_visibility is set to nil' do 
        before { group.latest_news_visibility = nil }

        it 'returns false' do 
          expect(subject.view_latest_news?).to eq false
        end
      end
    end

    context 'when manage_all is true' do 
      before { user.policy_group.update manage_all: true }

      context 'when group.latest_news_visibility is public' do 
        before { group.latest_news_visibility = 'public' }

        context 'when group_posts_index and manage_posts are false' do 
          before { user.policy_group.update manage_posts: false , group_posts_index: false }

          it 'returns false' do 
            expect(subject.view_latest_news?).to eq false
          end
        end

        context 'when group.latest_news_visibility is group' do 
          before { group.latest_news_visibility = 'group' }

          before { user.policy_group.update manage_posts: false , group_posts_index: false }

          it 'returns true' do 
            expect(subject.view_latest_news?).to eq true
          end
        end
      end
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }

    it 'returns false' do 
      expect(subject.view_latest_news?).to eq false
    end
  end  
end
