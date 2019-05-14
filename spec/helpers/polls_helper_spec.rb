require 'rails_helper'

RSpec.describe PollsHelper do
  let!(:enterprise) { create(:enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }
  let(:outcome) { create :outcome, group_id: group.id }
  let(:pillar) { create :pillar, outcome_id: outcome.id }
  let!(:initiative) { create :initiative, pillar: pillar, owner_group: group }
  let!(:poll) { create(:poll, initiative_id: initiative.id, enterprise: enterprise) }

  describe '#poll_initiative_visibility_class' do
    it 'return empty string' do
      params = {}
      expect(poll_initiative_visibility_class(poll, params)).to eq ''
    end

    it "returns 'hidden' string if params is blank" do
      params = {}
      poll.update(initiative_id: nil)
      expect(poll_initiative_visibility_class(poll, params)).to eq 'hidden'
    end
  end

  describe '#poll_others_visibility_class' do
    it "returns 'hidden' string" do
      params = {}
      expect(poll_others_visibility_class(poll, params)).to eq 'hidden'
    end
  end

  describe '#disabled_input' do
    it 'returns false if params[:initiative_id] is blank' do
      expect(disabled_input?).to eq false
    end

    it 'returns true if params[:initiative_id] is not blank' do
      params[:initiative_id] = initiative.id.to_s
      expect(disabled_input?).to eq true
    end
  end

  describe '#respondent_name' do
    it 'returns Anonymous User if response is anonymous' do
      expect(respondent_name(create(:poll_response, poll_id: poll.id))).to eq 'Anonymous User'
    end

    it "returns users's name with status" do
      poll_response = create(:poll_response, poll_id: poll.id, user_id: create(:user).id, anonymous: false)
      expect(respondent_name(poll_response)).to eq poll_response.user.name_with_status
    end

    it "returns 'Deleted User' when user is deleted" do
      poll_response = create(:poll_response, poll_id: poll.id, user_id: nil, anonymous: false)
      expect(respondent_name(poll_response)).to eq 'Deleted User'
    end
  end
end
