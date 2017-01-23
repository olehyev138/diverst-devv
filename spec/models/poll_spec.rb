require 'rails_helper'

RSpec.describe Poll, type: :model do
  describe "validation" do
    let(:poll){ build_stubbed(:poll) }

    it{ expect(poll).to validate_presence_of(:status) }
  end

  describe "enumerates" do
    context "status" do
      it{ expect(Poll.statuses[:published]).to eq 0 }
      it{ expect(Poll.statuses[:draft]).to eq 1 }
    end
  end
end
