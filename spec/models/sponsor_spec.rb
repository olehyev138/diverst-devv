require 'rails_helper'

RSpec.describe Sponsor, type: :model do
  describe 'validations' do
    let(:sponsor) { build_stubbed(:sponsor) }

    it { expect(sponsor).to have_attached_file(:sponsor_media) }
  end
end
