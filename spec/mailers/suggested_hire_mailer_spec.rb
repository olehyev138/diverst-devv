require "rails_helper"

RSpec.describe SuggestedHireMailer, type: :mailer do
  describe "suggest_hire" do
    let(:mail) { SuggestedHireMailer.suggest_hire }

    it "renders the headers" do
      expect(mail.subject).to eq("Suggest hire")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
