require 'rails_helper'

RSpec.describe UserGroupMailer, type: :mailer do
  let!(:user){ create(:user) }
  let!(:custom_text) { create(:custom_text, :erg => "BRG", :enterprise => user.enterprise)}
  let!(:email) { create(:email, :enterprise => user.enterprise, :mailer_name => "user_group_mailer", :mailer_method => "notification", :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of. Select the link(s) below to access Diverst and review the item(s)</p>\r\n", :subject => "You have updates in your %{custom_text.erg_text}")}
  let!(:email_variable_1) { create(:email_variable, :email => email, :enterprise_email_variable => create(:enterprise_email_variable, :key => "user.name"))}
  let!(:email_variable_2) { create(:email_variable, :email => email, :enterprise_email_variable => create(:enterprise_email_variable, :key => "custom_text.erg_text"), :pluralize => true)}
  let!(:groups){ [{ group: create(:group), events_count: 2, messages_count: 2, news_count: 0 }] }

  let!(:mail) { described_class.notification(user, groups).deliver_now }

  describe '#notification' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "You have updates in your BRGs"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message with number of comments in group' do
      expect(mail.body.encoded).to include("2 new messages")
    end
    
    it 'includes the interpolated fields such as users name' do
      expect(mail.body.encoded).to include(user.name)
    end

    it 'does not shows a message with number of news when there is news' do
      expect(mail.body.encoded).to_not include("news")
    end
  end
end
