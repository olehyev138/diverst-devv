require 'rails_helper'
require 'premailer'

RSpec.describe CsvUploadMailer, type: :mailer do
  describe '#result' do
    let(:csv_file) { create :csv_file }
    let!(:mail) { described_class.result([], [], 0, csv_file.user.enterprise_id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq 'User import result'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['tech@diverst.com'])
    end
  end
end
