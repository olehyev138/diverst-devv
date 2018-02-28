require 'rails_helper'

RSpec.describe Pillar, type: :model do
  let!(:pillar) { build(:pillar) }

  it { expect(pillar).to belong_to(:outcome) }
  it { expect(pillar).to have_many(:initiatives).dependent(:destroy) }
end
