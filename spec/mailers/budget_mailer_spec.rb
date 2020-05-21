require 'rails_helper'

RSpec.describe BudgetMailer, type: :mailer do
  describe '#approve_request' do
    let(:user) { create :user }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let(:budget) { create(:budget, group: group) }
    let(:view_budget_url) { group_budget_url(group, budget) }
    let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
    let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'budget_mailer', mailer_method: 'approve_request', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{group.name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n", subject: 'You are asked to review budget for %{group.name} %{custom_text.erg_text}') }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
    let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let(:mail) { described_class.approve_request(budget, user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to include(group.name)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'assigns @name' do
      escaped_name = Rack::Utils.escape_html user.name
      expect(mail.body.encoded).to include(escaped_name)
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
        .to include(view_budget_url)
    end
  end

  describe '#budget_approved' do
    let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano') }
    let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
    let(:group) { create(:group, name: 'New group', enterprise: approver.enterprise) }
    let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
    let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: requester.enterprise) }
    let!(:email) { create(:email, enterprise: requester.enterprise, mailer_name: 'budget_mailer', mailer_method: 'budget_approved', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been approved.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", subject: 'The budget for %{group.name} was approved') }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
    let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let(:mail) { described_class.budget_approved(budget).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq 'The budget for New group was approved'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [requester.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'renders the mail body' do
      expect(mail.body.encoded).to include 'Your budget request for'
    end
  end

  describe '#budget_declined' do
    let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano') }
    let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
    let(:group) { create(:group, name: 'New group', enterprise: requester.enterprise) }
    let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
    let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: requester.enterprise) }
    let!(:email) { create(:email, enterprise: requester.enterprise, mailer_name: 'budget_mailer', mailer_method: 'budget_declined', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been declined.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", subject: 'The budget for %{group.name} was declined') }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
    let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let(:mail) { described_class.budget_declined(budget).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq 'The budget for New group was declined'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [requester.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'renders the mail body' do
      expect(mail.body.encoded).to include 'Your budget request for'
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#approve_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:user) { create :user, enterprise: enterprise }
      let(:group) { create(:group, enterprise: user.enterprise) }
      let(:budget) { create(:budget, group: group) }
      let(:view_budget_url) { group_budget_url(group, budget) }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
      let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'budget_mailer', mailer_method: 'approve_request', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{group.name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n", subject: 'You are asked to review budget for %{group.name} %{custom_text.erg_text}') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:mail) { described_class.approve_request(budget, user).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#budget_approved' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano', enterprise: enterprise) }
      let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
      let(:group) { create(:group, name: 'New group', enterprise: approver.enterprise) }
      let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: requester.enterprise) }
      let!(:email) { create(:email, enterprise: requester.enterprise, mailer_name: 'budget_mailer', mailer_method: 'budget_approved', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been approved.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", subject: 'The budget for %{group.name} was approved') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:mail) { described_class.budget_approved(budget).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq [enterprise.redirect_email_contact]
      end
    end

    describe '#budget_declined' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano', enterprise: enterprise) }
      let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
      let(:group) { create(:group, name: 'New group', enterprise: requester.enterprise) }
      let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: requester.enterprise) }
      let!(:email) { create(:email, enterprise: requester.enterprise, mailer_name: 'budget_mailer', mailer_method: 'budget_declined', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been declined.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", subject: 'The budget for %{group.name} was declined') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:mail) { described_class.budget_declined(budget).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq [enterprise.redirect_email_contact]
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#approve_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:user) { create :user, enterprise: enterprise }
      let(:group) { create(:group, enterprise: user.enterprise) }
      let(:budget) { create(:budget, group: group) }
      let(:view_budget_url) { group_budget_url(group, budget) }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
      let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'budget_mailer', mailer_method: 'approve_request', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{group.name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n", subject: 'You are asked to review budget for %{group.name} %{custom_text.erg_text}') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mail) { described_class.approve_request(budget, user).deliver_now }

      it 'renders the receiver email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#budget_approved' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano', enterprise: enterprise) }
      let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
      let(:group) { create(:group, name: 'New group', enterprise: approver.enterprise) }
      let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: requester.enterprise) }
      let!(:email) { create(:email, enterprise: requester.enterprise, mailer_name: 'budget_mailer', mailer_method: 'budget_approved', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been approved.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", subject: 'The budget for %{group.name} was approved') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mail) { described_class.budget_approved(budget).deliver_now }

      it 'renders the receiver email' do
        expect(mail.to).to eq [fallback_email]
      end
    end

    describe '#budget_declined' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano', enterprise: enterprise) }
      let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
      let(:group) { create(:group, name: 'New group', enterprise: requester.enterprise) }
      let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: requester.enterprise) }
      let!(:email) { create(:email, enterprise: requester.enterprise, mailer_name: 'budget_mailer', mailer_method: 'budget_declined', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>Your budget request for: %{group.name}&nbsp;has been declined.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n", subject: 'The budget for %{group.name} was declined') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mail) { described_class.budget_declined(budget).deliver_now }

      it 'renders the receiver email' do
        expect(mail.to).to eq [fallback_email]
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#approve_request' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:user) { create :user, enterprise: enterprise }
      let(:group) { create(:group, enterprise: user.enterprise) }
      let(:budget) { create(:budget, group: group) }
      let(:mail) { described_class.approve_request(budget, user).deliver_now }

      it 'returns a null object' do
        expect(mail).to be(nil)
      end
    end

    describe '#budget_approved' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano', enterprise: enterprise) }
      let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
      let(:group) { create(:group, name: 'New group', enterprise: approver.enterprise) }
      let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
      let(:mail) { described_class.budget_approved(budget).deliver_now }

      it 'returns a null object' do
        expect(mail).to be(nil)
      end
    end

    describe '#budget_declined' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:approver) { create(:user, first_name: 'Fulano', last_name: 'Ciclano', enterprise: enterprise) }
      let(:requester) { create(:user, first_name: 'John', last_name: 'Doe', enterprise: approver.enterprise) }
      let(:group) { create(:group, name: 'New group', enterprise: requester.enterprise) }
      let(:budget) { create(:budget, requester: requester, approver: approver, group: group) }
      let(:mail) { described_class.budget_declined(budget).deliver_now }

      it 'returns a null object' do
        expect(mail).to be(nil)
      end
    end
  end
end
