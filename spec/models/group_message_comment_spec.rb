require 'rails_helper'

RSpec.describe GroupMessageComment, type: :model do
  describe 'when validating' do
    let(:group_message_comment) { build_stubbed(:group_message_comment) }

    it { expect(group_message_comment).to belong_to(:author) }
    it { expect(group_message_comment).to belong_to(:message) }
    it { expect(group_message_comment).to validate_presence_of(:author) }
    it { expect(group_message_comment).to validate_presence_of(:message) }
    it { expect(group_message_comment).to validate_presence_of(:content) }
  end
end
