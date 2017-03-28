require 'rails_helper'

RSpec.describe CustomText, type: :model do
  describe "when validating" do
    let(:custom_text){ build_stubbed(:custom_text) }

    it{ expect(custom_text).to belong_to(:enterprise) }
  end

  describe "#erg_text" do
    context "when erg is nil" do
      let(:custom_text){ build_stubbed(:custom_text, erg: nil)}

      it "returns the default text" do
        expect(custom_text.erg_text).to eq "ERG"
      end
    end

    context "when erg is present" do
      let(:custom_text){ build_stubbed(:custom_text, erg: "New ERG")}

      it "returns the erg text" do
        expect(custom_text.erg_text).to eq "New ERG"
      end
    end
  end
end
