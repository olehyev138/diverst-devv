require 'rails_helper'

RSpec.describe Poll, type: :model do
  describe "when validating" do
    let(:poll){ build_stubbed(:poll) }

    it{ expect(poll).to validate_presence_of(:status) }
    it{ expect(poll).to belong_to(:initiative) }

    context "enterprise_id of groups" do
      let(:poll){ create(:poll) }

      it "should be invalid when there is groups of another enterprises" do
        group = create(:group, enterprise: create(:enterprise))
        poll.groups << [group]
        poll.valid?

        expect(poll.errors.messages).to have_key(:groups)
      end

      it "should be valid when there is no groups of another enterprises" do
        group = create(:group, enterprise: poll.enterprise)
        poll.groups << [group]
        poll.valid?

        expect(poll.errors.messages).to_not have_key(:groups)
      end
    end

    context "enterprise_id of segments" do
      let(:poll){ create(:poll) }

      it "should be invalid when there is segments of another enterprises" do
        segment = create(:segment, enterprise: create(:enterprise))
        poll.segments << [segment]
        poll.valid?

        expect(poll.errors.messages).to have_key(:segments)
      end

      it "should be valid when there is no segments of another enterprises" do
        segment = create(:segment, enterprise: poll.enterprise)
        poll.segments << [segment]
        poll.valid?

        expect(poll.errors.messages).to_not have_key(:segments)
      end
    end

    context "enterprise_id of initiative" do
      let(:enterprise){ create(:enterprise) }
      let(:poll){ build(:poll, enterprise: enterprise, initiative: initiative) }

      context "when enterprise_id of initiative and poll are not the same" do
        let!(:initiative){ create(:initiative, owner_group_id: 0) }

        it "should be invalid" do
          poll.valid?
          expect(poll.errors.messages).to have_key(:initiative)
        end
      end

      context "when enterprise_id of initiative and poll are the same" do
        let(:pillar){ create(:pillar, outcome: outcome) }
        let(:outcome){ create(:outcome, group: group) }
        let(:group){ create(:group, enterprise: enterprise) }
        let!(:initiative){ create(:initiative, owner_group_id: group.id, pillar: pillar) }

        it "should be valid" do
          poll.valid?
          expect(poll.errors.messages).to_not have_key(:initiative)
        end
      end
    end
  end

  describe "enumerates" do
    context "status" do
      it{ expect(Poll.statuses[:published]).to eq 0 }
      it{ expect(Poll.statuses[:draft]).to eq 1 }
    end
  end
end
