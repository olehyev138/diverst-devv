require 'rails_helper'

RSpec.describe GroupMessage, type: :model do
  describe '#owner_name' do
    let!(:message) { create :group_message, owner: user }

    subject { message.owner_name }

    context 'with owner' do
      let(:user) { create :user }

      it 'returns correct name' do
        expect(subject).to include(user.first_name)
        expect(subject).to include(user.last_name)
      end
    end
    context 'without owner' do
      let(:user) { nil }
      it 'returns Unknown string' do
        expect(subject).to eq 'Unknown'
      end
    end
  end
end
