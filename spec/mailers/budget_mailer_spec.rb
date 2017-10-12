require 'rails_helper'

RSpec.describe BudgetMailer, type: :mailer do
  describe '#approve_request' do
    let(:user) { create :user }
    let(:budget) { create :budget }
    let(:group) { budget.subject }
    let(:view_budget_url) { group_budget_url(group, budget) }

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
    let(:approver){ create(:user, first_name: "Fulano", last_name: "Ciclano") }
    let(:requester){ create(:user, first_name: "John", last_name: "Doe") }
    let(:group){ create(:group, name: "New group") }
    let(:budget) { create(:budget, requester: requester, approver: approver, subject: group) }

    let(:mail) { described_class.budget_approved(budget).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "The budget for New group was approved"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [requester.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'renders message info' do
      expect(mail.body.encoded).to include("<html>\r\n  <body>\r\n    Hello, John Doe!\r\n<br/>\r\nYour budget New group has been approved by Fulano Ciclano\r\n  </body>\r\n</html>\r\n")
    end
  end

  describe '#budget_declined' do
    let(:approver){ create(:user, first_name: "Fulano", last_name: "Ciclano") }
    let(:requester){ create(:user, first_name: "John", last_name: "Doe") }
    let(:group){ create(:group, name: "New group") }
    let(:budget) { create(:budget, requester: requester, approver: approver, subject: group) }

    let(:mail) { described_class.budget_declined(budget).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "The budget for New group was declined"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [requester.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'renders message info' do
      expect(mail.body.encoded).to include("Your budget request for the New group has been denied by Fulano Ciclano. Please contact Fulano Ciclano to find out why it was declined")
    end
  end
end
