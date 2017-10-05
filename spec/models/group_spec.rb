require 'rails_helper'

RSpec.describe Group, :type => :model do
    describe 'validations' do
        let(:group) { FactoryGirl.build_stubbed(:group) }

        it{ expect(group).to validate_presence_of(:name) }
        
        it { expect(group).to belong_to(:enterprise) }
        it { expect(group).to belong_to(:lead_manager) }
        it { expect(group).to belong_to(:owner) }
        
        it{ expect(group).to have_many(:leaders).through(:group_leaders) }
        it{ expect(group).to have_many(:members).through(:user_groups) }
        it{ expect(group).to have_many(:polls).through(:groups_polls) }
        it{ expect(group).to have_many(:poll_responses).through(:polls) }
        it{ expect(group).to have_many(:poll_responses).through(:polls) }
        
        it { expect(group).to have_many(:events) }
        it { expect(group).to have_many(:own_initiatives) }
        it { expect(group).to have_many(:budgets) }
        it { expect(group).to have_many(:messages) }
        it { expect(group).to have_many(:news_links) }
        it { expect(group).to have_many(:social_links) }
        
        it { expect(group).to have_one(:news_feed)}
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
        let!(:group){ create(:group) }
        
        it "returns a csv file" do
            csv = group.survey_answers_csv    
            expect(csv).to eq("user_id,user_email,user_first_name,user_last_name\n")
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
    
    describe '#calendar_color' do
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
end
