require 'rails_helper'

RSpec.describe Field do
  describe "when validating" do
    let(:field){ build_stubbed(:field) }

    it { expect(field).to validate_presence_of(:title) }
  end

  describe ".numeric?" do
    context "when field is Numeric" do
      let(:numeric_field){ build_stubbed(:numeric_field) }

      it "returns true" do
        expect(numeric_field.numeric?).to eq true
      end
    end

    context "when field is not Numeric" do
      let(:non_numeric_field){ build_stubbed(:select_field) }

      it "returns false" do
        expect(non_numeric_field.numeric?).to eq false
      end
    end
  end
end
