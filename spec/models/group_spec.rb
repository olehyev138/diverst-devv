require 'rails_helper'

RSpec.describe Group do
  describe '#accept_user_to_group' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user) }
    let!(:group) { create(:group) }

    let(:user_id) { user.id }
    subject{ group.accept_user_to_group(user.id) }

    context 'with not existent user' do
      let!(:user_id) { nil }

      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context 'with existing user' do
      context 'when user is not a group member' do
        it 'returns false' do
          expect(subject).to eq false
        end
      end

      context 'when user is a group member' do
        before { user.groups << group }

        shared_examples "makes user an active member" do
          it 'returns true' do
            expect(subject).to eq true
          end

          it 'updates user model attribute' do
            subject

            user.reload
            expect(user.active_group_member?(group.id) ).to eq true
          end
        end

        context 'when user is not an active member' do
          it_behaves_like "makes user an active member"
        end

        context 'when user is already an active member' do
          it_behaves_like "makes user an active member"
        end
      end
    end
  end
end