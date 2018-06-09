require 'rails_helper'

RSpec.describe GroupLeaderCommentNotificationMailer, type: :mailer do
  
  let!(:leader){ create(:user) }
  let!(:group){ create(:group, :pending_users => "enabled") }
  let!(:user_group) {create(:user_group, :group => group, :user => leader, :accepted_member => true)} 
  let!(:group_leader){ create(:group_leader, :group => group, :user => leader) }

  let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

  describe '#notification' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "1 Pending Comment(s) for #{group.name.titleize}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([leader.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message with number of pending comments in group' do
      expect(mail.body.encoded).to include("#{group.name} has 1 pending comment")
    end
    
    it 'includes a link to the news feed' do
      expect(mail.body.encoded).to include("groups/#{group.id}/posts")
    end
  end
end
