require 'rails_helper'

RSpec.describe UsersDownloadMailer, type: :mailer do
  
  describe '#send_csv' do
    let!(:mail) { described_class.send_csv("test@gmail.com", "").deliver_now }
     
    it 'renders the subject' do
      expect(mail.subject).to eq "Diverst User Export Download"
    end
    
    it 'renders the receiver email' do
      expect(mail.to).to eq(["test@gmail.com"])
    end
  end
end
