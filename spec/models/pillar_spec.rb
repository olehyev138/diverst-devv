require 'rails_helper'

RSpec.describe Pillar, type: :model do
  let!(:pillar) { build_stubbed(:pillar) }

  it { expect(pillar).to belong_to(:outcome) }
  it { expect(pillar).to have_many(:initiatives).dependent(:destroy) }

  it { expect(pillar).to validate_length_of(:value_proposition).is_at_most(191) }
  it { expect(pillar).to validate_length_of(:name).is_at_most(191) }


  it '#name_with_group_prefix' do
    pillar1 = create(:pillar, outcome_id: create(:outcome, group_id: create(:group).id).id)
    parent_group = pillar1.outcome.group

    expect(pillar1.name_with_group_prefix).to eq "(#{parent_group.name}) #{pillar1.name}"
  end
end
