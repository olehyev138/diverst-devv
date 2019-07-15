require 'rails_helper'

RSpec.describe DiverstMailer, type: :mailer do
  context 'when enterprise disable_emails is false' do
    describe '#invitation_instructions' do
      let(:enterprise) { create(:enterprise, disable_emails: false) }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.invitation_instructions(record, 'token').deliver_now }

      it 'renders the receiver email' do
        expect(mail.to).to eq([record.email])
      end
    end

    describe '#reset_password_instructions' do
      let(:enterprise) { create(:enterprise, disable_emails: false) }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.reset_password_instructions(record, 'token').deliver_now }

      it 'renders the receiver email' do
        expect(mail.to).to eq([record.email])
      end
    end
  end

  context 'when enterprise disable_emails is true' do
    describe '#invitation_instructions' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.invitation_instructions(record, 'token').deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end

    describe '#reset_password_instructions' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.reset_password_instructions(record, 'token').deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#invitation_instructions' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.invitation_instructions(record, 'token').deliver_now }

      it 'renders the enterprise redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#reset_password_instructions' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.reset_password_instructions(record, 'token').deliver_now }

      it 'renders the enterprise redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#invitation_instructions' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.invitation_instructions(record, 'token').deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#reset_password_instructions' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.reset_password_instructions(record, 'token').deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end
  
  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#invitation_instructions' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, default_from_email_address: 'test@gmail.com', default_from_email_display_name: "The Best Company") }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.invitation_instructions(record, 'token').deliver_now }

      it 'renders the default_from_email_address' do
        expect(mail.from).to eq(["test@gmail.com"])
      end
    end
    
    describe '#invitation_instructions' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:record) { create :user, enterprise: enterprise }
      let!(:mail) { described_class.invitation_instructions(record, 'token').deliver_now }

      it 'renders info@diverst.com' do
        expect(mail.from).to eq(["info@diverst.com"])
      end
    end
  end
end
