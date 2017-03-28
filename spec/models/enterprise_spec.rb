require 'rails_helper'

RSpec.describe Enterprise, type: :model do
  describe "when validating" do
    let(:enterprise){ build_stubbed(:enterprise) }

    it{ expect(enterprise).to have_one(:custom_text) }
  end

  describe "#custom_text" do
    context "when enterprise does not have a custom_text" do
      let!(:enterprise){ create(:enterprise, custom_text: nil) }

      it "create a new custom_text" do
        expect(enterprise.custom_text).to be_an_instance_of(CustomText)
      end
    end

    context "when enterprise have a custom_text" do
      let!(:custom_text){ create(:custom_text) }
      let!(:enterprise){ create(:enterprise, custom_text: custom_text) }

      it "return the custom_text" do
        expect(enterprise.custom_text).to eq custom_text
      end
    end
  end

  describe ".cdo_message_email_html" do
    context "when cdo_message_email is not nil" do
      let(:enterprise){ build_stubbed(:enterprise, cdo_message_email: "test \r\n test") }

      it "change \r\n to br tag" do
        pending 'TODO: Move this check to Decorator, use decorator in views'
        expect(enterprise.cdo_message_email_html).to eq "test <br> test"
      end
    end
  end
end
