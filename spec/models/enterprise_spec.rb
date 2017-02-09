require 'rails_helper'

RSpec.describe Enterprise, type: :model do
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
