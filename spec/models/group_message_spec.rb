require 'rails_helper'

RSpec.describe GroupMessage, type: :model do
  describe 'test associations and validations' do
    let(:group_message) { build_stubbed(:group_message) }

    [:group_id, :subject, :content, :owner_id].each do |attribute|
      it { expect(group_message).to validate_presence_of(attribute) }
    end

    it { expect(group_message).to validate_length_of(:content).is_at_most(65535) }
    it { expect(group_message).to validate_length_of(:subject).is_at_most(191) }

    it { expect(group_message).to belong_to(:group) }
    it { expect(group_message).to belong_to(:owner).class_name('User') }

    it { expect(group_message).to have_many(:segments).through(:group_messages_segments) }

    it { expect(group_message).to have_many(:comments).class_name('GroupMessageComment').with_foreign_key(:message_id) }
    it { expect(group_message).to have_many(:group_messages_segments).dependent(:destroy) }
    it { expect(group_message).to have_many(:segments).through(:group_messages_segments) }
    it { expect(group_message).to have_one(:news_feed_link) }

    it { expect(group_message).to delegate_method(:increment_view).to(:news_feed_link) }
    it { expect(group_message).to delegate_method(:total_views).to(:news_feed_link) }
    it { expect(group_message).to delegate_method(:unique_views).to(:news_feed_link) }

    it { expect(group_message).to accept_nested_attributes_for(:news_feed_link).allow_destroy(true) }
  end

  describe 'test callbacks' do
    context 'test before_create callback' do
      let!(:group_message) { build(:group_message) }

      it 'run build_default_link before create' do
        expect(group_message).to receive(:build_default_link)
        group_message.save
      end
    end

    context 'test after_create callback' do
      let!(:group_message) { build(:group_message) }

      it 'run approve_link after create' do
        group_message.save
        expect(group_message).to receive(:approve_link)
        group_message.run_callbacks(:create)
      end
    end

    context '#destroy_callbacks' do
      it 'removes the child objects' do
        group_message = create(:group_message)
        group_messages_segment = create(:group_messages_segment, group_message: group_message)
        group_message_comment = create(:group_message_comment, message: group_message)

        group_message.destroy!

        expect { GroupMessage.find(group_message.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { GroupMessagesSegment.find(group_messages_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { GroupMessageComment.find(group_message_comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '.of_segments' do
    let(:owner) { create(:user) }
    let(:group) { build(:group, enterprise: owner.enterprise) }

    let(:segment1) { build :segment, enterprise: owner.enterprise }
    let(:segment2) { build :segment, enterprise: owner.enterprise }

    let!(:group_message_without_segment) { create(:group_message, owner_id: owner.id, segments: []) }
    let!(:group_message_with_segment) { create(:group_message, owner_id: owner.id, segments: [segment1]) }
    let!(:group_message_with_another_segment) {
      build(:group_message, owner_id: owner.id, segments: [segment2])
    }

    it 'returns initiatives that has specific segments or does not have any segment' do
      expect(GroupMessage.of_segments([segment1.id])).to match_array([group_message_without_segment, group_message_with_segment])
    end
  end

  describe '#owner_name' do
    let(:user) { build_stubbed :user }
    let!(:message) { build_stubbed :group_message, owner: user }

    subject { message.owner_name }

    it 'returns correct name' do
      expect(subject).to include(user.first_name)
      expect(subject).to include(user.last_name)
    end
  end

  describe '#comments_count' do
    let!(:group_message) { create(:group_message) }
    let!(:approved_comments) { create_list(:group_message_comment, 2, message_id: group_message.id, approved: true) }
    let!(:comments) { create_list(:group_message_comment, 2, message_id: group_message.id) }

    it 'when enterprise has pending comments enabled' do
      group_message.group.enterprise.update enable_pending_comments: true
      expect(group_message.comments_count).to eq 2
    end

    it 'when enterprise has pending comments disabled' do
      expect(group_message.comments_count).to eq 4
    end
  end

  describe '#users' do
    let!(:group_message) { create(:group_message, group: create(:group)) }
    let!(:group) { group_message.group }
    let!(:user) { create(:user, enterprise: group.enterprise) }
    before { create(:user_group, user: user, group: group) }

    it 'when segments.empty? is true' do
      expect(group_message.users).to eq([user])
    end

    it 'when segments.empty? false' do
      group_message.segments << create(:segment, enterprise_id: group.enterprise_id)
      expect(group_message.users).to eq([])
    end
  end

  describe '#news_feed_link' do
    it 'has default news_feed_link' do
      group_message = create(:group_message)
      expect(group_message.news_feed_link).to_not be_nil
    end
  end

  describe '#remove_segment_association' do
    it 'removes segment association' do
      group_message = create(:group_message)
      segment = create(:segment)

      group_message.segment_ids = [segment.id]
      group_message.save

      expect(group_message.segments.length).to eq(1)
      expect(group_message.group_messages_segments.length).to eq(1)

      group_messages_segment = group_message.group_messages_segments.where(segment_id: segment.id).first

      expect(group_messages_segment.news_feed_link_segment).to_not be(nil)

      group_message.remove_segment_association(segment)

      expect(group_messages_segment.news_feed_link_segment).to_not be(nil)
    end
  end

  describe '#users' do
    let(:user) { create :user }
    let(:group) { build :group, enterprise: user.enterprise }
    let!(:user_group) { create :user_group, group: group, user: user }
    let!(:group_message) { build :group_message, owner: user, group: group }

    it 'returns 1 user' do
      expect(group_message.users.count).to eq(1)
    end

    it 'returns no user' do
      segment = build(:segment)
      create(:group_messages_segment, segment: segment, group_message: group_message)

      expect(group_message.users.count).to eq(0)
    end
  end

  describe '#send_emails' do
    let(:group_message) { create :group_message }
  end

  describe 'elasticsearch methods', skip: true do
    context '#as_indexed_json' do
      let!(:object) { create(:group_message) }

      it 'serializes the correct fields with the correct data' do
        hash = {
          'created_at' => object.created_at.beginning_of_hour,
          'group' => {
            'enterprise_id' => object.group.enterprise_id,
            'name' => object.group.name,
            'parent_id' => object.group.parent_id
          }
        }
        expect(object.as_indexed_json).to eq(hash)
      end
    end
  end
end
