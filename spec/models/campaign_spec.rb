require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'when validating' do
    let(:campaign) { build_stubbed(:campaign) }

    it { expect(campaign).to define_enum_for(:status).with([:published, :draft]) }
    it { expect(campaign).to belong_to(:enterprise) }
    it { expect(campaign).to belong_to(:owner) }
    it { expect(campaign).to have_many(:questions) }
    it { expect(campaign).to have_many(:answers).through(:questions) }
    it { expect(campaign).to have_many(:answer_comments).through(:questions) }
    it { expect(campaign).to have_many(:campaigns_groups) }
    it { expect(campaign).to have_many(:groups).through(:campaigns_groups) }
    it { expect(campaign).to have_many(:campaigns_segments) }
    it { expect(campaign).to have_many(:segments).through(:campaigns_segments) }
    it { expect(campaign).to have_many(:invitations) }
    it { expect(campaign).to have_many(:users).through(:invitations) }
    it { expect(campaign).to have_many(:campaigns_managers) }
    it { expect(campaign).to have_many(:managers).through(:campaigns_managers) }
  end
end
