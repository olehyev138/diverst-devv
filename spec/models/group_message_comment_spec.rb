require 'rails_helper'

RSpec.describe GroupMessageComment, type: :model do
  describe 'when validating' do
    let(:group_message_comment) { build_stubbed(:group_message_comment) }

    it { expect(group_message_comment).to belong_to(:author).class_name('User') }
    it { expect(group_message_comment).to belong_to(:message).class_name('GroupMessage') }
    it { expect(group_message_comment).to validate_presence_of(:author) }
    it { expect(group_message_comment).to validate_presence_of(:message) }
    it { expect(group_message_comment).to validate_presence_of(:content) }
  end


  describe 'test scopes' do
    context '#unapproved' do
      it 'returns the group_message_comments that have not been approved' do
        create_list(:group_message_comment, 2, approved: false)
        expect(GroupMessageComment.unapproved.count).to eq(2)
      end
    end

    context '#approved' do
      it 'returns approved group message comments' do
        create_list(:group_message_comment, 3, approved: true)
        expect(GroupMessageComment.approved.count).to eq 3
      end
    end
  end
end
