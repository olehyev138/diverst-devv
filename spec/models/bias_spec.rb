require 'rails_helper'

RSpec.describe Bias, type: :model do
  describe 'when validating' do
    let(:bias) { build_stubbed(:bias) }

    it { expect(bias).to belong_to(:user) }
    it { expect(bias).to have_and_belong_to_many(:groups_from) }
    it { expect(bias).to have_and_belong_to_many(:groups_to) }
    it { expect(bias).to have_and_belong_to_many(:cities_from) }
    it { expect(bias).to have_and_belong_to_many(:cities_to) }
    it { expect(bias).to have_and_belong_to_many(:departments_from) }
    it { expect(bias).to have_and_belong_to_many(:departments_to) }
  end
end
