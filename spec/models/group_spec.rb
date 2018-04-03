require 'rails_helper'

RSpec.describe Group, :type => :model do

    describe 'validations' do
        let(:group) { FactoryGirl.build_stubbed(:group) }

        it{ expect(group).to validate_presence_of(:name) }

        it { expect(group).to belong_to(:enterprise) }
        it { expect(group).to belong_to(:lead_manager).class_name('User') }
        it { expect(group).to belong_to(:owner).class_name('User') }

        it { expect(group).to have_one(:news_feed).dependent(:destroy) }

        it { expect(group).to delegate_method(:news_feed_links).to(:news_feed) }


        it { expect(group).to have_many(:user_groups).dependent(:destroy) }
        it{ expect(group).to have_many(:members).through(:user_groups).class_name('User').source(:user) }
        it { expect(group).to have_many(:groups_polls) }
        it{ expect(group).to have_many(:polls).through(:groups_polls) }
        it{ expect(group).to have_many(:leaders).through(:group_leaders) }
        it{ expect(group).to have_many(:poll_responses).through(:polls).source(:responses) }
        it { expect(group).to have_many(:events) }

        it { expect(group).to have_many(:own_initiatives).class_name('Initiative').with_foreign_key('owner_group_id') }
        it { expect(group).to have_many(:initiative_participating_groups) }
        it { expect(group).to have_many(:participating_initiatives).through(:initiative_participating_groups).source(:initiative) }
        it { expect(group).to have_many(:budgets) }
        it { expect(group).to have_many(:messages).class_name('GroupMessage') }
        it { expect(group).to have_many(:message_comments).through(:messages).class_name('GroupMessageComment').source(:comments) }
        it { expect(group).to have_many(:news_links).dependent(:destroy) }
        it { expect(group).to have_many(:news_link_comments).through(:news_links).class_name('NewsLinkComment').source(:comments) }
        it { expect(group).to have_many(:social_links).dependent(:destroy) }
        it { expect(group).to have_many(:invitation_segments_groups) }
        it { expect(group).to have_many(:invitation_segments).class_name('Segment').through(:invitation_segments_groups) }
        it { expect(group).to have_many(:resources) }
        it { expect(group).to have_many(:folders) }
        it { expect(group).to have_many(:folder_shares) }
        it { expect(group).to have_many(:shared_folders).through(:folder_shares).source('folder') }
        it { expect(group).to have_many(:campaigns_groups) }
        it { expect(group).to have_many(:campaigns).through(:campaigns_groups) }
        it { expect(group).to have_many(:questions).through(:campaigns) }
        it { expect(group).to have_many(:answers).through(:questions) }
        it { expect(group).to have_many(:answer_upvotes).through(:answers).source(:votes) }
        it { expect(group).to have_many(:answer_comments).through(:answers).class_name('AnswerComment').source(:comments) }
        it { expect(group).to have_many(:outcomes) }
        it { expect(group).to have_many(:pillars).through(:outcomes) }
        it { expect(group).to have_many(:initiatives).through(:pillars) }
        it { expect(group).to have_many(:updates).class_name('GroupUpdate').dependent(:destroy) }
        it { expect(group).to have_many(:fields) }
        it { expect(group).to have_many(:survey_fields).class_name('Field').dependent(:destroy) }
        it { expect(group).to have_many(:group_leaders) }
        it { expect(group).to have_many(:leaders).through(:group_leaders).source(:user) }
        it { expect(group).to have_many(:children).class_name('Group').with_foreign_key(:parent_id) }
        it { expect(group).to belong_to(:parent).class_name('Group').with_foreign_key(:parent_id) }


        it { expect(group).to belong_to(:group_category)}
        it { expect(group).to belong_to(:group_category_type)}

        [:logo, :banner, :sponsor_media].each do |attribute|
          it { expect(group).to have_attached_file(attribute) }
        end

        [:logo, :banner].each do |attribute|
          it { expect(group).to validate_attachment_content_type(attribute).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
        end

        [:outcomes, :fields, :survey_fields, :group_leaders].each do |attribute|
           it { expect(group).to accept_nested_attributes_for(attribute).allow_destroy(true) }
        end

        it { expect(group).to validate_presence_of(:name) }

        describe '#perform_check_for_consistency_in_category' do
          let!(:category_type1) { create(:group_category_type, name: "New Category1") }
          let!(:categories_of_category_type1) { create_list(:group_category, 2, group_category_type_id: category_type1.id) }
          let!(:category_type2) { create(:group_category_type, name: "New Category2") }
          let!(:categories_of_category_type2) { create_list(:group_category, 2, group_category_type_id: category_type2.id) }
          let!(:parent_group) { create(:group, parent_id: nil, group_category_id: nil, group_category_type_id: category_type1.id) }

          it 'return error message for wrong label' do
            sub_group = build(:group, parent_id: parent_group.id, group_category_id: categories_of_category_type2.first.id, group_category_type_id: category_type2.id)
            sub_group.valid?
            expect(sub_group.errors.messages[:group_category]).to eq ['wrong label for New Category1']
          end
        end

        describe '#valid_yammer_group_link?' do
          context 'with valid yammer group link' do
            let(:link) { 'https://www.yammer.com/diverst.com/#/threads/inGroup?type=in_group&feedId=6830281' }

            before { group.yammer_group_link = link }

            it 'is returns true' do
              expect(group).to be_valid
            end
          end

          context 'with invalid yammer group link' do
            let(:link) { 'https://google.com' }

            before { group.yammer_group_link = link }

            it 'returns false' do
              expect(group).to_not be_valid
            end
          end
        end

        describe '#ensure_one_level_nesting' do
          let!(:group) { create(:group) }
          let(:parent_group) { create(:group, enterprise: group.enterprise) }
          let(:child_group) { create(:group, enterprise: group.enterprise) }

          context 'with parent only' do
            before { group.parent = parent_group }

            it 'is valid' do
              expect(group).to be_valid
            end
          end

          context 'with children only' do
            before { group.children << child_group }

            it 'is valid' do
              expect(group).to be_valid
            end
          end

          context 'with both parent and children' do
            before do
              group.parent = parent_group
              group.children << child_group
            end

            it 'is invalid' do
              expect(group).to_not be_valid

              expect(group.errors.messages[:parent_id]).to include "group can't have both parent and children"
            end
          end
        end
    end

    describe '#yammer_group_id' do
      let(:group) { FactoryGirl.build_stubbed(:group) }

      subject { group.yammer_group_id }

      context 'with link' do
        context 'with correct link' do
          let(:link) { 'https://www.yammer.com/diverst.com/#/threads/inGroup?type=in_group&feedId=6830281' }

          before { group.yammer_group_link = link }
          it 'returns correct group id' do
            expect(subject).to eq 6830281
          end
        end

        context 'with incorrect link' do
          let(:link) { 'https://google.com' }

          before { group.yammer_group_link = link }

          it 'returns nil' do
            expect(subject).to be_nil
          end
        end
      end

      context 'without yammer link' do
        let(:link) { nil }
        before { group.yammer_group_link = link }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end

    describe '#accept_user_to_group' do
        let!(:enterprise) { create(:enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:group) { create(:group, enterprise: enterprise) }

        let(:user_id) { user.id }
        subject{ group.accept_user_to_group(user.id) }

        context 'with not existent user' do
            let!(:user_id) { nil }

            it 'returns false' do
                expect(subject).to eq false
            end
        end

        context 'with existing user' do
            context 'when user is not a group member' do
                it 'returns false' do
                    expect(subject).to eq false
                end
            end

            context 'when user is a group member' do
                before { user.groups << group }

                shared_examples "makes user an active member" do
                    it 'returns true' do
                        expect(subject).to eq true
                    end

                    it 'updates user model attribute' do
                        subject

                        user.reload
                        expect(user.active_group_member?(group.id)).to eq true
                    end
                end

                context 'when user is not an active member' do
                    it_behaves_like "makes user an active member"
                end

                context 'when user is already an active member' do
                    it_behaves_like "makes user an active member"
                end
            end
        end
    end

    describe 'when describing callbacks' do
        let!(:group){ create(:group) }

        it "should reindex users on elasticsearch after destroy" do
            TestAfterCommit.with_commits(true) do
                expect(group).to receive(:update_all_elasticsearch_members)
                group.destroy
            end
        end
    end

    describe '#survey_answers_csv' do
        it "returns a csv file" do
            group = create(:group)
            field = create(:field, :field_type => "group_survey", :container => group)
            user = create(:user)
            user_group = create(:user_group, :user => user, :group => group, :data => "{\"13\":\"test\"}")

            csv = CSV.generate do |file|
                file << ['user_id', 'user_email', 'user_first_name', 'user_last_name'].concat(group.survey_fields.map(&:title))
                file << [user.id, user.email, user.first_name, user.last_name, field.csv_value(user_group.info[field])]
            end

            result = group.survey_answers_csv
            expect(result).to eq(csv)
        end
    end

    describe 'members fetching by type' do
        let(:enterprise) { create :enterprise }
        let!(:group) { create :group, enterprise: enterprise }
        let!(:active_user) { create :user, enterprise: enterprise, active: true }
        let!(:inactive_user) { create :user, enterprise: enterprise, active: false }
        let!(:pending_user) { create :user, enterprise: enterprise }

        before do
            group.members << active_user
            group.members << pending_user

            group.accept_user_to_group(active_user.id)
        end

        context 'with disabled pending members setting' do
            describe '#active_members' do
                subject { group.active_members }

                it 'contain all group users' do
                    expect(subject).to include active_user
                    expect(subject).to include pending_user
                end
            end

            describe '#pending_members' do
                subject { group.pending_members }

                it 'contains no user' do
                    expect(subject).to_not include pending_user
                    expect(subject).to_not include active_user
                end
            end
        end

        context 'with enabled pending members setting' do
            before { group.pending_users = 'enabled' }

            describe '#active_members' do
                subject { group.active_members }

                it 'contains active user' do
                    expect(subject).to include active_user
                end

                it 'does not contains pending user' do
                    expect(subject).to_not include [pending_user, inactive_user]
                end
            end

            describe '#pending_members' do
                subject { group.pending_members }

                it 'contains pending user' do
                    expect(subject).to include pending_user
                end

                it 'does not contains active user' do
                    expect(subject).to_not include [active_user, inactive_user]
                end
            end
        end
    end

    describe '#managers' do
        it "returns an array with nil" do
            group = create(:group)
            expect(group.managers.length).to eq(1)
            expect(group.managers[0]).to be_nil
        end

        it "returns an array with user" do
            user = create(:user)
            group = create(:group, :owner => user)

            expect(group.managers.length).to eq(1)
            expect(group.managers[0]).to be(user)
        end

        it "returns an array with owner and leaders" do
            user = create(:user)
            group = create(:group, :owner => user)

            2.times do
                create(:group_leader, :group => group, :user => user)
            end

            expect(group.managers.length).to eq(3)
        end
    end

    describe '#calendar_color', :skip => true do
        it "returns cccccc" do
            group = create(:group)
            expect(group.calendar_color).to eq("cccccc")
        end

        it "returns theme primary_color" do
            theme = create(:theme)
            enterprise = create(:enterprise, :theme => theme)
            group = create(:group, :enterprise => enterprise)
            expect(group.calendar_color).to eq(enterprise.theme.primary_color)
        end
    end

    describe '#approved_budget' do
        it "returns 0" do
            group = create(:group)
            expect(group.approved_budget).to eq(0)
        end

        it "returns 0" do
            group = create(:group)

            budget = create(:budget, :subject => group, :is_approved => true)
            create(:budget_item, :budget => budget, :estimated_amount => 1000)

            expect(group.approved_budget).to be > 0
        end
    end

    describe '#available_budget' do
        it "returns 0" do
            group = create(:group)
            expect(group.available_budget).to eq(0)
        end

        it "returns available budget" do
            group = create(:group, :annual_budget => 10000)

            budget = create(:budget, :subject => group, :is_approved => true)
            create(:budget_item, :budget => budget, :estimated_amount => 1000)
            expect(group.available_budget).to eq(group.annual_budget - group.approved_budget)
        end
    end

    describe '#news_feed' do
        it "returns news_feed" do
            group = create(:group)
            expect(group.news_feed).to_not be(nil)
        end

        it "returns news_feed event after destroy" do
            group = create(:group)

            expect(group.news_feed).to_not be(nil)
            group.news_feed.destroy

            expect(group.news_feed).to_not be(nil)
        end
    end

    describe '#parent' do
        it "returns nil" do
            group = create(:group)
            expect(group.parent).to be(nil)
        end

        it "returns parent" do
            group_1 = create(:group)
            group_2 = create(:group, :parent => group_1)

            expect(group_2.parent).to_not be(nil)
            expect(group_2.parent).to eq(group_1)
        end
    end

    describe '#children' do
        it "returns empty array" do
            group = create(:group)
            expect(group.children.length).to eq(0)
        end

        it "returns 1 child" do
            group_1 = create(:group)
            group_2 = create(:group, :parent => group_1)

            expect(group_1.children).to include(group_2)
        end
    end

    describe '#avg_members_per_group' do
        it "returns 2" do
            enterprise = create(:enterprise)
            user_1 = create(:user, :enterprise => enterprise)
            user_2 = create(:user, :enterprise => enterprise)
            group_1 = create(:group, :enterprise => enterprise)
            group_2 = create(:group, :enterprise => enterprise)
            create(:user_group, :user => user_1, :group => group_1)
            create(:user_group, :user => user_2, :group => group_1)
            create(:user_group, :user => user_1, :group => group_2)
            create(:user_group, :user => user_2, :group => group_2)

            average = Group.avg_members_per_group(:enterprise => enterprise)
            expect(average).to eq(2)
        end
    end

    describe '#file_safe_name' do
        it "returns file_safe_name" do
            group = create(:group, :name => "test name")
            expect(group.file_safe_name).to eq("test_name")
        end
    end

    describe '#possible_participating_groups' do
        it "returns possible_participating_groups" do
            enterprise = create(:enterprise)
            group_1 = create(:group, :enterprise => enterprise)
            create(:group, :enterprise => enterprise)
            expect(group_1.possible_participating_groups.length).to eq(1)
        end
    end

    describe '#highcharts_history' do
        it "returns highcharts_history" do
            group = create(:group)
            field = create(:field)
            create(:group_update, :group => group)
            data = group.highcharts_history(:field => field)
            expect(data.length).to eq(1)
        end
    end

    describe '#title_with_leftover_amount' do
        it "returns title_with_leftover_amount" do
            group = create(:group)
            expect(group.title_with_leftover_amount).to eq("Create event from #{group.name} leftover ($#{group.leftover_money})")
        end
    end

    describe '#sync_yammer_users' do
        it "subscribe yammer users to group" do
            yammer = double("YammerClient")
            allow(YammerClient).to receive(:new).and_return(yammer)
            allow(yammer).to receive(:user_with_email).and_return({"id" => 1, "yammer_token" => nil})
            allow(yammer).to receive(:token_for_user).and_return({"token" => "token"})
            allow(yammer).to receive(:subscribe_to_group)

            group = create(:group)
            user = create(:user)
            create(:user_group, :user => user, :group => group)

            group.sync_yammer_users

            expect(yammer).to have_received(:subscribe_to_group)
        end
    end

    describe '#pending_comments_count' do
        it "returns 0" do
            group = create(:group)
            expect(group.pending_comments_count).to eq(0)
        end

        it "returns 1" do
            group = create(:group)
            group_message = create(:group_message, :group => group)
            create(:group_message_comment, :message => group_message, :approved => false)
            expect(group.pending_comments_count).to eq(1)
        end

        it "returns 2" do
            group = create(:group)
            group_message = create(:group_message, :group => group)
            create(:group_message_comment, :message => group_message, :approved => false)
            news_link = create(:news_link, :group => group)
            create(:news_link_comment, :news_link => news_link, :approved => false)
            expect(group.pending_comments_count).to eq(2)
        end

        it "returns 3" do
            group = create(:group)
            # group message
            group_message = create(:group_message, :group => group)
            create(:group_message_comment, :message => group_message, :approved => false)
            # news link
            news_link = create(:news_link, :group => group)
            create(:news_link_comment, :news_link => news_link, :approved => false)
            # campaign
            campaign = create(:campaign)
            create(:campaigns_group, :group => group, :campaign => campaign)
            question = create(:question, campaign: campaign)
            answer = create(:answer, question: question)
            create(:answer_comment, answer: answer, approved: false)

            expect(group.pending_comments_count).to eq(3)
        end
    end

    describe '#valid_yammer_group_link?' do
        it "has a valid link" do
            group = build(:group, :yammer_group_link => "https://www.yammer.com/test.com/#/threads/inGroup?type=in_group&feedId=1234567")
            expect(group.valid_yammer_group_link?).to be(true)
        end

        it "does not have a valid link" do
            group = build(:group, :yammer_group_link => "https://www.yammer.com/test.com/#/threads/inGroup?type")
            expect(group.valid_yammer_group_link?).to be(false)
            expect(group.errors.full_messages.length).to eq(1)
            expect(group.errors.full_messages.first).to eq("Yammer group link this is not a yammer group link")
        end
    end

    describe "#company_video_url" do
        it "saves the url" do
            group = create(:group, :company_video_url => "https://www.youtube.com/watch?v=Y2VF8tmLFHw")
            expect(group.company_video_url).to_not be(nil)
        end
    end

    describe '#build_default_news_feed' do 
        let!(:new_group) { build(:group) }

        it 'builds default news feed' do 
            expect(new_group).to receive(:build_default_news_feed)
            new_group.save
        end
    end

    describe "#create_yammer_group" do
        it "creates the group in yammer and syncs the members" do
            yammer = double("YammerClient")
            allow(YammerClient).to receive(:new).and_return(yammer)
            allow(yammer).to receive(:create_group).and_return({"id" => 1})
            allow(SyncYammerGroupJob).to receive(:perform_later)

            enterprise = create(:enterprise, :yammer_token => "token")
            group = create(:group, :enterprise => enterprise, :yammer_create_group => true, :yammer_group_created => false)

            expect(yammer).to have_received(:create_group)
            expect(group.yammer_group_created).to be(true)
            expect(group.yammer_id).to eq(1)
            expect(SyncYammerGroupJob).to have_received(:perform_later)
        end
    end

    describe "#send_invitation_emails" do
        it "calls GroupMailer" do
            allow(GroupMailer).to receive(:delay).and_return(GroupMailer)
            allow(GroupMailer).to receive(:invitation)

            group = create(:group)
            segment = create(:segment)
            create(:invitation_segments_group, :group => group, :invitation_segment => segment)

            # make sure group has invitation_segments
            group.reload
            expect(group.invitation_segments.count).to eq(1)

            # change the value
            group.send_invitations = true
            group.save!

            expect(GroupMailer).to have_received(:invitation)
            expect(group.send_invitations).to be(false)
            expect(group.invitation_segments.count).to eq(0)
        end
    end

    describe "#update_all_elasticsearch_members" do
        it "updates the users in elasticsearch" do
            group = create(:group)
            user = create(:user)
            create(:user_group, :group => group, :user => user)
            allow(group).to receive(:update_elasticsearch_member).and_call_original

            group.name = "testing elasticsearch"
            group.save!

            expect(group).to have_received(:update_elasticsearch_member)
        end
    end

    describe '#set_default_group_contact' do
        it 'updates contact email if group leader is default_group_contact' do
            group = create(:group)
            user = create(:user)
            group_leader = create(:group_leader, :group => group, :user => user, :default_group_contact => true)
            group_leader = group.group_leaders.find_by(default_group_contact: true)&.user
        

            expect(group.contact_email).to eq group_leader&.email
        end

        it 'sets contact email to nil if group leader is not set.' do
            group = create(:group)
            user = create(:user)
            create(:group_leader, :group => group, :user => user, :default_group_contact => false)
            group_leader = group.group_leaders.find_by(default_group_contact: true)&.user

            expect(group.contact_email).to eq nil
        end
    end
    
    describe "#private scopes" do
        it "should return correct group counts" do
            enterprise = create(:enterprise)
            create_list(:group, 5, :private => true, :enterprise => enterprise)
            create_list(:group, 3, :private => false, :enterprise => enterprise)
            
            expect(enterprise.groups.count).to eq(8)
            expect(enterprise.groups.is_private.count).to eq(5)
            expect(enterprise.groups.non_private.count).to eq(3)
        end
    end
end
