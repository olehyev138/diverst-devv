require 'rails_helper'

#RSpec.describe UserGroupMailer, type: :mailer do
#  let!(:enterprise) { create(:enterprise, default_from_email_address: 'test@diverst.com', default_from_email_display_name: 'THE BEST COMPANY IN THE WORLD!') }
#  let!(:user) { create(:user, enterprise: enterprise) }
#  let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
#  let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'user_group_mailer', mailer_method: 'notification', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of. Select the link(s) below to access Diverst and review the item(s)</p>\r\n", subject: 'You have updates in your %{custom_text.erg_text}') }
#  let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
#  let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text'), pluralize: true) }
#  let!(:group_1) {create(:group)}
#  let!(:groups) {[{
#                     group: group_1,
#                     events: [create(:initiative, owner_group_id: group_1.id),
#                              create(:initiative, owner_group_id: group_1.id),
#                              create(:initiative, owner_group_id: group_1.id)],
#                     events_count: 3,
#                     messages: [create(:group_message, group_id: group_1.id, owner_id: user.id),
#                                create(:group_message, group_id: group_1.id, owner_id: user.id)],
#                     messages_count: 2,
#                     news: [],
#                     news_count: 0,
#                     social_links: [],
#                     social_links_count: 0,
#                     participating_events: [],
#                     participating_events_count: 0
#                    }] }
#
#  let!(:mail) { described_class.notification(user, groups).deliver_now }
#
#  describe '#notification' do
#    it 'the email is queued' do
#      expect(ActionMailer::Base.deliveries).to_not be_empty
#    end
#
#    it 'renders the subject' do
#      expect(mail.subject).to eq 'You have updates in your BRGs'
#    end
#
#    it 'renders the receiver email' do
#      expect(mail.to).to eq([user.email])
#    end
#
#    it 'renders the sender email' do
#      expect(mail.from).to eq(['test@diverst.com'])
#    end
#
#    it 'renders the sender display name' do
#      expect(mail[:from].display_names).to eq(['THE BEST COMPANY IN THE WORLD!'])
#    end
#
#    # TODO expand the scope of these test
#
#    it 'shows a the name of all items' do
#      expect(mail.body.encoded).to include(groups[0][:events][0].name)
#      expect(mail.body.encoded).to include(groups[0][:events][1].name)
#      expect(mail.body.encoded).to include(groups[0][:events][2].name)
#
#      expect(mail.body.encoded).to include(groups[0][:messages][0].subject)
#      expect(mail.body.encoded).to include(groups[0][:messages][1].subject)
#    end
#
#    it 'doesn\'t show a message with number of remaining items in group if less than or equal to 2' do
#      expect(mail.body.encoded).not_to include('new message')
#    end
#
#    it 'includes the interpolated fields such as users name' do
#      expect(mail.body.encoded).to include(user.name)
#    end
#
#    it 'does not shows a message with number of news when there is news' do
#      expect(mail.body.encoded).to_not include('news')
#    end
#  end
#
#  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
#    describe '#notification' do
#      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
#      let!(:user) { create(:user, enterprise: enterprise) }
#      let!(:groups) {[{
#                        group: group_1,
#                        events: [create(:initiative, owner_group_id: group_1.id),
#                                 create(:initiative, owner_group_id: group_1.id)],
#                        events_count: 2,
#                        messages: [create(:group_message, group_id: group_1.id, owner_id: user.id),
#                                   create(:group_message, group_id: group_1.id, owner_id: user.id)],
#                        messages_count: 2,
#                        news: [],
#                        news_count: 0,
#                        social_links: [],
#                        social_links_count: 0,
#                        participating_events: [],
#                        participating_events_count: 0
#                      }] }
#
#      let!(:mail) { described_class.notification(user, groups).deliver_now }
#
#      it 'renders the redirect_email_contact' do
#        expect(mail.to).to eq([enterprise.redirect_email_contact])
#      end
#    end
#  end
#
#  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
#    describe '#notification' do
#      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
#      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
#      let!(:user) { create(:user, enterprise: enterprise) }
#      let!(:groups) {[{
#                        group: group_1,
#                        events: [create(:initiative, owner_group_id: group_1.id),
#                                 create(:initiative, owner_group_id: group_1.id)],
#                        events_count: 2,
#                        messages: [create(:group_message, group_id: group_1.id, owner_id: user.id),
#                                   create(:group_message, group_id: group_1.id, owner_id: user.id)],
#                        messages_count: 2,
#                        news: [],
#                        news_count: 0,
#                        social_links: [],
#                        social_links_count: 0,
#                        participating_events: [],
#                        participating_events_count: 0
#                      }] }
#
#      let!(:mail) { described_class.notification(user, groups).deliver_now }
#
#      it 'renders the fallback_email' do
#        expect(mail.to).to eq([fallback_email])
#      end
#    end
#  end
#
#  context 'when enterprise wants to stop all emails' do
#    describe '#notification' do
#      let(:enterprise) { create(:enterprise, disable_emails: true) }
#      let!(:user) { create(:user, enterprise: enterprise) }
#      let!(:groups) {[{
#                        group: group_1,
#                        events: [create(:initiative, owner_group_id: group_1.id),
#                                 create(:initiative, owner_group_id: group_1.id)],
#                        events_count: 2,
#                        messages: [create(:group_message, group_id: group_1.id, owner_id: user.id),
#                                   create(:group_message, group_id: group_1.id, owner_id: user.id)],
#                        messages_count: 2,
#                        news: [],
#                        news_count: 0,
#                        social_links: [],
#                        social_links_count: 0,
#                        participating_events: [],
#                        participating_events_count: 0
#                      }] }
#
#      let!(:mail) { described_class.notification(user, groups).deliver_now }
#
#      it 'renders null mail object' do
#        expect(mail).to be(nil)
#      end
#    end
#  end
#end
