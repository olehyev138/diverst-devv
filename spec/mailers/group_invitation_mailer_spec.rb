require "rails_helper"

RSpec.describe GroupInvitationMailer, type: :mailer do
  include ActionView::Helpers


  context '#invitation' do 
    let!(:enterprise) { create(:enterprise, disable_emails: false) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:invited_by) { create(:user, enterprise: enterprise) }
    let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'group_invitation_mailer', 
                                                               mailer_method: 'invitation',
                                                               content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have been invited to join <strong> %{group.name} </strong>.</p><p>%{click_here} to join %{group.name} %{enterprise.custom_text.erg_text}</p></p>",
                                                               subject: "Invitation to join #{group.name}") }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'enterprise.name')) }
  
    let!(:mail) { described_class.invitation(group.id, user.id).deliver_now }

    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      # byebug
      expect(mail.subject).to eq "Invitation to join #{group.name}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message to user' do
      expect(mail.body.decoded).to include('You have been invited to join')
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:invited_by) { create(:user, enterprise: enterprise) }
    let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'group_invitation_mailer', 
                                                               mailer_method: 'invitation',
                                                               content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have been invited to join <strong> %{group.name} </strong>.</p><p>%{click_here} to join %{group.name} %{enterprise.custom_text.erg_text}</p></p>",
                                                               subject: "Invitation to join #{group.name}") }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'enterprise.name')) }
  
    let!(:mail) { described_class.invitation(group.id, user.id).deliver_now }

    describe '#invitation' do      
      it 'renders the redirect email contact' do
        expect(mail.to).to eq(['test@gmail.com'])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#invitation' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let!(:group) { create(:group, enterprise: enterprise) }
      let!(:user) { create(:user, enterprise: enterprise) }
      let!(:invited_by) { create(:user, enterprise: enterprise) }
      let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'group_invitation_mailer', 
                                                                mailer_method: 'invitation',
                                                                content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have been invited to join <strong> %{group.name} </strong>.</p><p>%{click_here} to join %{group.name} %{enterprise.custom_text.erg_text}</p></p>",
                                                                subject: "Invitation to join #{group.name}") }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'enterprise.name')) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let!(:mail) { described_class.invitation(group.id, user.id).deliver_now }


      it 'renders the redirect email contact' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#invitation' do
      let!(:enterprise) { create(:enterprise, disable_emails: true) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:invited_by) { create(:user, enterprise: enterprise) }
    let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'group_invitation_mailer', 
                                                               mailer_method: 'invitation',
                                                               content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have been invited to join <strong> %{group.name} </strong>.</p><p>%{click_here} to join %{group.name} %{enterprise.custom_text.erg_text}</p></p>",
                                                               subject: "Invitation to join #{group.name}") }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'enterprise.name')) }
  
    let!(:mail) { described_class.invitation(group.id, user.id).deliver_now }


      it 'renders a null mail object' do
        expect(mail).to be(nil)
      end
    end
  end
end
