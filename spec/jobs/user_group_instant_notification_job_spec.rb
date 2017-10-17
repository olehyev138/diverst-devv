require 'rails_helper'

RSpec.describe UserGroupInstantNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:user){ create(:user) }
  let(:group){ create(:group) }
  let(:group_message){create(:group_message, :group => group, :author => user)}
  
  context "when user accept to receive real time notifications" do
    let!(:user_group){
      create(:user_group, group: group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:real_time])
    }

    it "send an email of notification to members of group with real_time setting" do
      mailer = double("mailer")
      expect(UserGroupMailer).to receive(:notification)
        .with(user, [{ group: group, messages_count: 1, news_count: 0 }]){ mailer }
      expect(mailer).to receive(:deliver_now)
      subject.perform(group, link: group_message, link_type: "GroupMessage")
    end
  end
  
  context "when user is member of segment" do
    let!(:user_group){
      create(:user_group, group: group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:real_time])
    }

    it "send an email" do
      segment = create(:segment, :enterprise => user.enterprise)
      create(:users_segment, :user => user, :segment => segment)
      mailer = double("mailer")
      expect(UserGroupMailer).to receive(:notification)
        .with(user, [{ group: group, messages_count: 1, news_count: 0 }]){ mailer }
      expect(mailer).to receive(:deliver_now)
      subject.perform(group, link: group_message, link_type: "GroupMessage")
    end
    
    it "send an email when link is member of segment" do
      segment = create(:segment, :enterprise => user.enterprise)
      create(:users_segment, :user => user, :segment => segment)
      create(:group_messages_segment, :group_message => group_message, :segment => segment)
      mailer = double("mailer")
      expect(UserGroupMailer).to receive(:notification)
        .with(user, [{ group: group, messages_count: 1, news_count: 0 }]){ mailer }
      expect(mailer).to receive(:deliver_now)
      subject.perform(group, link: group_message, link_type: "GroupMessage")
    end
    
    it "does not send an email when link is member of segment and user is not" do
      segment = create(:segment, :enterprise => user.enterprise)
      create(:group_messages_segment, :group_message => group_message, :segment => segment)
      mailer = double("mailer")
      expect(UserGroupMailer).to_not receive(:notification)
        .with(user, [{ group: group, messages_count: 1, news_count: 0 }]){ mailer }
      expect(mailer).to_not receive(:deliver_now)
      subject.perform(group, link: group_message, link_type: "GroupMessage")
    end
  end

  context "when user does not accept to receive real time notifications" do
    let!(:user_group){
      create(:user_group, group: group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:disabled])
    }

    it "send an email of notification to members of group with real_time setting" do
      expect(UserGroupMailer).to_not receive(:notification)
      subject.perform(group, link: group_message, link_type: "GroupMessage")
    end
  end
  
end
