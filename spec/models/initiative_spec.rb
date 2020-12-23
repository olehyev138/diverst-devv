require 'rails_helper'

RSpec.describe Initiative, type: :model do
  include ActiveJob::TestHelper
  it_behaves_like 'it Defines Fields'

  describe 'when validating' do
    let(:initiative) { build(:initiative) }

    it { expect(initiative).to belong_to(:pillar) }
    it { expect(initiative).to belong_to(:owner).class_name('User') }
    it { expect(initiative).to have_many(:updates).class_name('Update').dependent(:destroy) }
    it { expect(initiative).to have_many(:fields).dependent(:destroy) }
    it { expect(initiative).to have_many(:expenses).dependent(:destroy).class_name('InitiativeExpense') }

    it { expect(initiative).to accept_nested_attributes_for(:fields).allow_destroy(true) }

    it { expect(initiative).to validate_length_of(:location).is_at_most(191) }
    it { expect(initiative).to validate_length_of(:description).is_at_most(65535) }
    it { expect(initiative).to validate_length_of(:name).is_at_most(191) }

    it { expect(initiative).to belong_to(:budget_item) }
    it { expect(initiative).to have_one(:budget).through(:budget_item) }
    it { expect(initiative).to have_one(:annual_budget).through(:budget) }

    it { expect(initiative).to have_many(:checklists).dependent(:destroy) }
    it { expect(initiative).to have_many(:resources).dependent(:destroy) }

    it { expect(initiative).to have_many(:checklist_items).dependent(:destroy) }
    it { expect(initiative).to accept_nested_attributes_for(:checklist_items).allow_destroy(true) }

    it { expect(initiative).to belong_to(:owner_group).class_name('Group') }

    it { expect(initiative).to have_many(:initiative_segments).dependent(:destroy) }
    it { expect(initiative).to have_many(:segments).through(:initiative_segments) }
    it { expect(initiative).to have_many(:initiative_participating_groups).dependent(:destroy) }
    it { expect(initiative).to have_many(:participating_groups).through(:initiative_participating_groups).source(:group).class_name('Group') }

    it { expect(initiative).to have_many(:initiative_invitees).dependent(:destroy) }
    it { expect(initiative).to have_many(:invitees).through(:initiative_invitees).source(:user) }
    it { expect(initiative).to have_many(:comments).class_name('InitiativeComment').dependent(:destroy) }

    it { expect(initiative).to have_many(:initiative_users).dependent(:destroy) }
    it { expect(initiative).to have_many(:attendees).through(:initiative_users).source(:user) }

    # ActiveStorage
    it { expect(initiative).to have_attached_file(:picture) }
    it { expect(initiative).to validate_attachment_content_type(:picture, AttachmentHelper.common_image_types) }
    it { expect(initiative).to have_attached_file(:qr_code) }
    it { expect(initiative).to validate_attachment_content_type(:qr_code, AttachmentHelper.common_image_types) }

    it { expect(initiative).to validate_presence_of(:start) }
    it { expect(initiative).to validate_presence_of(:end) }
    it { expect(initiative).to validate_presence_of(:pillar) }
    it { expect(initiative).to validate_presence_of(:owner_group) }
    it { expect(initiative).to validate_numericality_of(:max_attendees).is_greater_than(0).allow_nil }
    it { expect(initiative).to have_many(:user_reward_actions) }
    it { expect(initiative).to have_one(:outcome).through(:pillar) }
    it { expect(initiative).to have_one(:group).through(:outcome) }
    it { expect(initiative.end).to be >= initiative.start }

    context 'segment_enterprise' do
      let!(:user) { create(:user) }

      it "and have segments with enterprise not equal to owner's enterprise" do
        segment = build(:segment)
        initiative = build(:initiative, owner_id: user.id, segments: [segment])
        initiative.valid?

        expect(initiative.errors.messages).to have_key(:segments)
        expect(initiative).to be_invalid
      end

      it "and all segments with enterprise equal to owner's enterprise" do
        segment = build(:segment, enterprise: user.enterprise)
        initiative = build(:initiative, owner_id: user.id, segments: [segment])

        expect(initiative).to be_valid
      end
    end
  end

  describe 'test scopes' do
    context 'initiative::starts_between' do
      let!(:starts_between_initiatives) { create_list(:initiative, 3, start: Date.today) }

      it 'returns initiative starts_between' do
        expect(Initiative.starts_between(Date.yesterday, Date.tomorrow).count).to eq 3
      end
    end

    context 'initiative::past' do
      let!(:past_initiatives) { create_list(:initiative, 3, start: 2.days.ago, end: Date.yesterday) }

      it 'returns initiative past' do
        expect(Initiative.past.count).to eq 3
      end
    end

    context 'initiative::upcoming' do
      let!(:upcoming_initiatives1) { create(:initiative, start: Date.tomorrow) }
      let!(:upcoming_initiatives2) { create(:initiative, start: 2.days.from_now) }

      it 'returns initiative upcoming' do
        expect(Initiative.upcoming[0]).to eq(upcoming_initiatives1)
        expect(Initiative.upcoming[1]).to eq(upcoming_initiatives2)
      end
    end

    context 'initiative::ongoing' do
      let!(:ongoing_initiatives1) { create(:initiative, start: 2.days.ago, end: Date.tomorrow) }
      let!(:ongoing_initiatives2) { create(:initiative, start: Date.yesterday, end: Date.tomorrow) }

      it 'returns initiative ongoing' do
        expect(Initiative.ongoing[0]).to eq(ongoing_initiatives2)
        expect(Initiative.ongoing[1]).to eq(ongoing_initiatives1)
      end
    end

    context '.recent' do
      let!(:past_initiative) { create(:initiative, created_at: 61.days.ago) }
      let!(:recent_initiative) { create(:initiative, created_at: 1.day.ago) }

      it 'return initiatives created in the last 60 days' do
        expect(Initiative.recent).to eq [recent_initiative]
      end
    end

    context '.of_segments' do
      let(:owner) { create(:user) }
      let(:segment) { create(:segment, enterprise: owner.enterprise) }
      let!(:initiative_without_segment) { create(:initiative, owner_id: owner.id, segments: []) }
      let!(:initiative_with_segment) { create(:initiative, owner_id: owner.id, segments: [segment]) }
      let!(:initiative_with_another_segment) {
        create(:initiative, owner_id: owner.id, segments: [create(:segment, enterprise: owner.enterprise)])
      }

      it 'returns initiatives that has specific segments or does not have any segment' do
        expect(Initiative.of_segments([segment.id])).to match_array([initiative_without_segment, initiative_with_segment])
      end
    end

    context 'initiative::of_annual_budget' do
      let!(:annual_budget) { create :annual_budget, id: 100 }
      let!(:budget) { create(:approved_budget, annual_budget: annual_budget) }
      let!(:annual_budget_initiative) { create :initiative, budget_item: budget.budget_items.first }

      it 'returns initiative of_annual_budget' do
        expect(Initiative.of_annual_budget(100)).to eq([annual_budget_initiative])
      end
    end

    context 'initiative::joined_events_for_user' do
      let!(:user) { create(:user, id: 1) }
      let!(:user2) { create(:user, id: 2) }
      before do
        create(:initiative_user, user: user, initiative: create(:initiative))
        create(:initiative_invitee, user: user, initiative: create(:initiative))
        create(:initiative_invitee, user: user2, initiative: create(:initiative))
      end
      it 'returns initiative joined_events_for_user' do
        expect(Initiative.joined_events_for_user(1).count).to eq 2
      end
    end

    context 'initiative::available_events_for_user' do
      let!(:user1) { create(:user, id: 1) }
      let!(:user2) { create(:user, id: 2) }
      let!(:group1) { create(:group) }
      let!(:group2) { create(:group) }
      let!(:pillar) { create(:pillar, outcome_id: create(:outcome, group_id: group2.id).id) }
      before do
        create(:user_group, user: user1, group: group1)
        create(:user_group, user: user2, group: group2)
        create(:initiative_invitee, user: user1, initiative: create(:initiative))
        create(:initiative_participating_group, group: group1, initiative: create(:initiative))
        create(:initiative, pillar_id: pillar.id)
      end
      it 'returns initiative available_events_for_user user1' do
        expect(Initiative.available_events_for_user(1).distinct.count).to eq 2
      end
      it 'returns initiative available_events_for_user user2' do
        expect(Initiative.available_events_for_user(2).distinct.count).to eq 1
      end
    end

    context 'initiative::order_recent' do
      let!(:order_recent_initiatives) { create_list(:initiative, 3) }

      it 'returns initiative order_recent' do
        expect(Initiative.order_recent).to eq(order_recent_initiatives.sort_by { |i| i.start }.reverse)
      end
    end

    context 'initiative::finalized' do
      let!(:finalized_initiatives) { create_list(:initiative, 3, finished_expenses: true) }

      it 'returns initiative finalized' do
        expect(Initiative.finalized.count).to eq 3
      end
    end

    context 'initiative::active' do
      let!(:active_initiatives) { create_list(:initiative, 3, finished_expenses: false) }

      it 'returns initiative active' do
        expect(Initiative.active.count).to eq 3
      end
    end

    context 'initiative::archived' do
      let!(:not_archived_initiatives) { create_list(:initiative, 3) }
      let!(:archived_initiatives) { create_list(:initiative, 2, archived_at: Date.today) }
      it 'returns initiative not_archived' do
        expect(Initiative.not_archived.count).to eq 3
      end
      it 'returns initiative archived' do
        expect(Initiative.archived.count).to eq 2
      end
    end
  end

  describe '#build' do
    it 'sets the picture for initiative from url when creating initiative' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      outcome = create(:outcome, group: group)
      pillar = create(:pillar, outcome: outcome)

      file = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')

      request = Request.create_request(user)
      payload = { initiative: { name: 'Save', pillar_id: pillar.id, picture: file, owner_group_id: group.id, owner_id: user.id, start: Date.today, end: Date.tomorrow + 1.day } }
      params = ActionController::Parameters.new(payload)
      created = Initiative.build(request, params.permit!)

      expect(created.picture.attached?).to be true
    end
  end

  describe 'elasticsearch methods' do
    context '#as_indexed_json' do
      let!(:object) { create(:initiative) }

      it 'serializes the correct fields with the correct data' do
        hash = {
            'name' => object.name,
            'created_at' => object.created_at.beginning_of_hour,
            'pillar' => {
                'outcome' => {
                    'group' => {
                        'id' => object.pillar.outcome.group_id,
                        'enterprise_id' => object.pillar.outcome.group.enterprise_id,
                        'name' => object.pillar.outcome.group.name,
                        'parent_id' => object.pillar.outcome.group.parent_id
                    }
                }
            }
        }
        expect(object.as_indexed_json).to eq(hash)
      end
    end
  end

  describe '#picture_location' do
    it 'returns the actual picture location' do
      initiative = create(:initiative, picture: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(initiative.picture_location).to_not be nil
    end
  end

  describe '#qr_code_location' do
    it 'returns the actual qr_code location' do
      initiative = create(:initiative, qr_code: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(initiative.qr_code_location).to_not be nil
    end
  end

  describe '.initiative_date' do
    let(:initiative) { build_stubbed(:initiative) }

    context 'when date_type is not valid' do
      it 'return an empty string' do
        expect(initiative.initiative_date('unknown')).to eq ''
      end
    end

    context 'when date_type is start' do
      it 'when there is not an start date return an empty string' do
        initiative.start = nil
        expect(initiative.initiative_date('start')).to eq ''
      end

      it 'when there is an start date return a reversed_slashes string' do
        initiative.start = Date.parse('2017-01-01')
        expect(initiative.initiative_date('start')).to eq '2017/01/01'
      end
    end

    context 'when date_type is end' do
      it 'when there is not an end date return an empty string' do
        initiative.end = nil
        expect(initiative.initiative_date('end')).to eq ''
      end

      it 'when there is an end date return a reversed_slashes string' do
        initiative.end = Date.parse('2017-01-01')
        expect(initiative.initiative_date('end')).to eq '2017/01/01'
      end
    end
  end

  describe '#ended?' do
    let!(:initiative) { create(:initiative, end: DateTime.tomorrow) }

    it 'returns false' do
      expect(initiative.ended?).to eq(false)
    end

    it 'returns true' do
      initiative.update(end: DateTime.yesterday)
      expect(initiative.ended?).to eq(true)
    end
  end

  describe '#archived?' do
    let!(:initiative) { create(:initiative) }

    it 'returns false' do
      expect(initiative.archived?).to eq(false)
    end

    it 'returns true' do
      initiative.update(archived_at: DateTime.now)
      expect(initiative.archived?).to eq(true)
    end
  end

  describe '#group' do
    let!(:group) { create(:group) }
    let!(:initiative) { create(:initiative, owner_group: group) }

    it 'returns group' do
      expect(initiative.group).to eq(group)
    end

    it 'returns group_id' do
      expect(initiative.group_id).to eq(group.id)
    end
  end

  describe '#enterprise' do
    let!(:group) { create(:group) }
    let!(:initiative) { create(:initiative, owner_group: group) }

    it 'returns enterprise' do
      expect(initiative.enterprise).to eq(group.enterprise)
    end

    it 'returns enterprise_id' do
      expect(initiative.enterprise_id).to eq(group.enterprise_id)
    end
  end

  describe '#total_comments' do
    let!(:initiative) { create(:initiative) }
    let!(:initiative_comment) { create_list(:initiative_comment, 5, initiative_id: initiative.id) }
    it 'returns total comments' do
      expect(initiative.total_comments).to eq 5
    end
  end

  describe '#total_attendees' do
    let!(:initiative) { create(:initiative) }
    before do
      users = create_list(:user, 5)
      users.each do |u|
        create(:initiative_user, initiative: initiative, user: u)
      end
    end
    it 'returns total attendees' do
      expect(initiative.total_attendees).to eq 5
    end
  end

  describe 'annual_budget_id' do
    let!(:initiative) { create(:initiative, :with_budget_item) }
    it 'returns annual_budget_id' do
      expect(initiative.annual_budget_id).to eq initiative.annual_budget.id
    end
  end

  describe '#description' do
    let(:initiative) { build(:initiative, description: nil) }

    it "returns '' when description is nil" do
      expect(initiative.description).to eq('')
    end

    it 'returns description' do
      initiative.description = 'brief description'
      expect(initiative.description).to eq('brief description')
    end
  end

  describe '#budget_status' do
    let(:initiative) { build(:initiative) }

    it 'returns Not attached' do
      expect(initiative.budget_status).to eq('Not attached')
    end
  end

  describe '#expenses_status' do
    it 'returns Expenses in progress' do
      initiative = build(:initiative)
      expect(initiative.expenses_status).to eq('Expenses in progress')
    end

    it 'returns Expenses finished' do
      initiative = build(:initiative, finished_expenses: true)
      expect(initiative.expenses_status).to eq('Expenses are already finished')
    end
  end

  describe '#approved?' do
    it 'returns true if no budget exists' do
      initiative = create(:initiative)

      expect(initiative.approved?).to eq(true)
    end

    it 'returns true' do
      budget = build(:budget, is_approved: true, budget_items: build_list(:budget_item, 1))
      budget_item = budget.budget_items.first
      initiative = create(:initiative, budget_item_id: budget_item.id)

      expect(initiative.approved?).to eq(true)
    end

    it 'returns false' do
      budget = create(:budget, is_approved: false, budget_items: build_list(:budget_item, 1))
      budget_item = budget.budget_items.first
      initiative = build(:initiative, budget_item_id: budget_item.id)

      expect(initiative.approved?).to eq(false)
    end
  end

  describe '#pending?' do
    it 'returns false' do
      initiative = create(:initiative)
      expect(initiative.pending?).to eq(false)
    end

    it 'returns false' do
      budget = create(:budget, is_approved: true, budget_items: build_list(:budget_item, 1))
      budget_item = budget.budget_items.first
      initiative = create(:initiative, budget_item_id: budget_item.id)

      expect(initiative.pending?).to eq(false)
    end

    it 'returns false' do
      budget = create(:budget, is_approved: false, budget_items: build_list(:budget_item, 1))
      budget_item = budget.budget_items.first
      initiative = build(:initiative, budget_item_id: budget_item.id)

      expect(initiative.pending?).to eq(true)
    end
  end

  describe '#finish_expenses!' do
    let!(:initiative) { create(:initiative, finished_expenses: true) }

    it 'returns false' do
      expect(initiative.finish_expenses!).to eq(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      group = create(:group, enterprise: enterprise, annual_budget: 10000)
      annual_budget = create(:annual_budget, group: group, enterprise: enterprise, amount: group.annual_budget)
      budget = create(:approved_budget, annual_budget: annual_budget)
      initiative1 = create(:initiative, owner_group: group, budget_item_id: budget.budget_item_ids.first)

      expect(initiative1.finish_expenses!).to eq(true)
    end
  end

  describe '#unfinished_expenses?' do
    let!(:initiative) { create(:initiative, start: 2.days.ago, end: Date.yesterday) }
    it 'returns false' do
      expect(initiative.unfinished_expenses?).to eq(false)
    end

    it 'returns true' do
      initiative.update(end: Date.tomorrow, finished_expenses: false)
      expect(initiative.unfinished_expenses?).to eq(true)
    end

    it 'returns false' do
      initiative.update(finished_expenses: true)
      expect(initiative.unfinished_expenses?).to eq(false)
    end
  end

  describe '#current_expenses_sum' do
    it 'return 0' do
      annual_budget = create(:annual_budget)
      budget = create(:approved_budget, annual_budget: annual_budget)
      initiative = create(:initiative, budget_item_id: budget.budget_item_ids.first)
      expect(initiative.current_expenses_sum).to eq(0)
    end
  end

  describe '#has_no_estimated_funding?' do
    let(:initiative) { build(:initiative) }

    it 'returns true' do
      expect(initiative.has_no_estimated_funding?).to eq(true)
    end
  end

  describe '#leftover' do
    it 'returns 0' do
      initiative = build(:initiative, :with_budget_item)
      expect(initiative.leftover).to eq(0)
    end
  end

  describe '#title' do
    it 'returns name of initiative' do
      initiative = build(:initiative)
      expect(initiative.title).to eq(initiative.name)
    end
  end

  describe 'test callbacks' do
    let!(:new_initiative) { build(:initiative) }

    it '#allocate_budget_funds' do
      expect(new_initiative).to receive(:allocate_budget_funds)
      new_initiative.save
    end
  end

  describe 'budgeting' do
    let(:group) { create(:group) }

    context 'without funds' do
      let(:initiative) { build(:initiative, owner_group: group, estimated_funding: 0) }

      it 'is valid without budget' do
        expect(initiative).to be_valid
      end
    end

    context 'with funds' do
      let(:initiative) { build(:initiative, owner_group: group, estimated_funding: 100) }

      context 'without budget' do
        it 'is not valid' do
          expect(initiative).to_not be_valid
        end
      end

      context 'with incorrect budget' do
        let(:new_budget) { build(:budget) }

        before { initiative.budget = new_budget }

        it 'is not valid' do
          expect(initiative).to_not be_valid
        end
      end

      context 'with correct budget item' do
        let!(:initiative) { create(:initiative, :with_budget_item, estimated_funding: 1000) }

        context 'with enough budget money' do
          let!(:estimated_funding) { initiative.estimated_funding }
          let!(:available_amount) { initiative.budget_item.available_amount }

          it 'saves initiative with correct funding' do
            expect(initiative).to_not be_new_record

            expect(initiative.estimated_funding).to eq estimated_funding
          end

          it 'substracts estimated funding from budget item' do
            expect(initiative.budget_item.available_amount).to eq 0
          end

          it 'marks budget item as done', skip: 'redefine IsDone later' do
            expect(initiative.budget_item.is_done).to eq true
          end
        end
      end

      context 'with leftover money', skip: 'Temporarily Disabled Use of leftover money' do
        before do
          group.annual_budget = 2000
          annual_budget = group.current_annual_budget
          budget = FactoryBot.create(:approved_budget, annual_budget: annual_budget)
          budget_item = budget.budget_items.first
          budget_item.update(estimated_amount: 1000)
        end

        let(:initiative) { build :initiative, budget_item_id: -1 }

        it 'is valid' do
          expect(initiative).to be_valid
        end
      end
    end
  end

  describe 'start/end' do
    it 'validates end' do
      initiative = build(:initiative, start: Date.tomorrow, end: Date.today)
      expect(initiative.valid?).to eq(false)
      expect(initiative.errors.full_messages.first).to eq('End must be after start')
    end
  end

  describe '#time_string' do
    # TODO: timestring doesnt exist
    it 'returns day and start/end time' do
      pending
      initiative = build(:initiative, start: Date.today, end: Date.today + 1.hour)
      expect(initiative.time_string).to eq("#{initiative.start.to_s :dateonly} from #{initiative.start.to_s :ampmtime} to #{initiative.end.to_s :ampmtime}")
    end
  end

  describe '#highcharts_history' do
    it 'returns highcharts_history' do
      initiative = create(:initiative)
      field = create(:field)
      create(:update, updatable: initiative, report_date: 30.days.ago)
      data = initiative.highcharts_history(field: field)
      expect(data.length).to eq(1)
    end
  end

  describe '#highcharts_history_all_fields' do
    it 'returns highcharts_history for all fields' do
      initiative = create(:initiative)
      fields = create_list(:field, 3)
      create(:update, updatable: initiative, report_date: 30.days.ago)
      data = initiative.highcharts_history_all_fields(fields: fields.pluck(:id))
      expect(data.length).to eq(3)
    end
  end

  describe '#expenses_highcharts_history' do
    it 'returns expenses_highcharts_history' do
      initiative = create(:initiative, :with_budget_item)
      create(:initiative_expense, initiative: initiative)
      data = initiative.expenses_highcharts_history
      expect(data.length).to eq(1)
    end
  end

  describe '#funded_by_leftover?' do
    it '#returns false' do
      initiative = build(:initiative)
      expect(initiative.funded_by_leftover?).to eq(false)
    end
  end

  describe '#group_ids' do
    let(:initiative) { create(:initiative, owner_group: create(:group)) }

    it 'returns group ids' do
      expect(initiative.group_ids).to eq([initiative.owner_group.id])
    end
  end

  describe '#full?' do
    let(:initiative) { create(:initiative) }
    before { create_list(:initiative_user, 3, initiative: initiative) }

    it 'return true' do
      initiative.max_attendees = 2
      expect(initiative.full?).to eq(true)
    end

    it 'return false' do
      expect(initiative.full?).to eq(false)
    end
  end

  describe '#expenses_time_series_csv' do
    let(:initiative) { build(:initiative) }

    it 'returns csv' do
      expect(initiative.expenses_time_series_csv).to include('Expenses over time')
    end
  end

  describe '#field_time_series_csv' do
    let(:initiative) { build(:initiative) }
    let!(:field) { create(:field) }
    it 'returns csv' do
      expect(initiative.field_time_series_csv(field.id)).to_not be nil
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      group = create(:group, annual_budget: 10000)
      annual_budget = create(:annual_budget, amount: group.annual_budget)
      budget = create(:approved_budget, annual_budget: annual_budget)
      initiative = create(:initiative, owner_group_id: group.id, budget_item: budget.budget_items.first)
      initiative_update = create(:update, updatable: initiative)
      field = create(:field, field_definer: initiative)
      initiative_expense = create(:initiative_expense, initiative: initiative)
      checklist = create(:checklist, initiative: initiative)
      resource = create(:resource, initiative: initiative)
      checklist_item = create(:checklist_item, initiative: initiative)
      initiative_segment = create(:initiative_segment, initiative: initiative)
      initiative_participating_group = create(:initiative_participating_group, initiative: initiative)
      initiative_invitee = create(:initiative_invitee, initiative: initiative)
      initiative_comment = create(:initiative_comment, initiative: initiative)
      initiative_user = create(:initiative_user, initiative: initiative)

      initiative.reload
      initiative.destroy!

      expect { Initiative.find(initiative.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Update.find(initiative_update.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Field.find(field.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeExpense.find(initiative_expense.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Checklist.find(checklist.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Resource.find(resource.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { ChecklistItem.find(checklist_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeSegment.find(initiative_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeParticipatingGroup.find(initiative_participating_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeInvitee.find(initiative_invitee.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeComment.find(initiative_comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeUser.find(initiative_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'protected' do
    describe 'update_owner_group' do
      let!(:group) { create :group, :without_outcomes }
      let!(:outcome) { create :outcome, group_id: group.id }
      let!(:pillar) { create :pillar, outcome_id: outcome.id }
      let!(:initiative) { build(:initiative, pillar: pillar, owner_group: nil) }
      it 'updates owner group' do
        expect(initiative.send(:update_owner_group)).to eq group.id
      end
    end

    describe 'check_budget' do
      it 'returns true if estimated_funding is 0' do
        initiative = build(:initiative)
        expect(initiative.send(:check_budget)).to eq true
      end

      it 'returns true' do
        initiative = create(:initiative, :with_budget_item, estimated_funding: 10)
        expect(initiative.send(:check_budget)).to eq true
      end

      it 'returns false if group id is different' do
        initiative = create(:initiative, :with_budget_item, estimated_funding: 10)
        group1 = create(:group)
        AnnualBudget.first.update(group_id: group1.id)
        initiative.budget.reload
        expect(initiative.send(:check_budget)).to eq false
      end

      it 'returns true if it is LEFTOVER_BUDGET_ITEM_ID' do
        initiative = build(:initiative, estimated_funding: 10, budget_item_id: BudgetItem::LEFTOVER_BUDGET_ITEM_ID)
        expect(initiative.send(:check_budget)).to eq true
      end

      it 'returns error message if no budget' do
        initiative = build(:initiative, estimated_funding: 10)
        expect(initiative.send(:check_budget)).to eq ['Can not create event with funds but without budget']
      end
    end

    describe 'budget_item_is_approved' do
      it 'returns nil' do
        initiative = create(:initiative)
        expect(initiative.send(:budget_item_is_approved)).to be nil
      end

      it 'returns nil' do
        initiative = create(:initiative, :with_budget_item)
        expect(initiative.send(:budget_item_is_approved)).to be nil
      end

      it 'returns error' do
        initiative = create(:initiative, :with_budget_item)
        initiative.budget.update(is_approved: false)
        expect(initiative.send(:budget_item_is_approved)).to eq ['Budget Item is not approved']
      end
    end
  end

  describe '.archived_initiatives' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:initiative) { create(:initiative, owner_group: group) }
    let!(:archived_initiatives) { create_list(:initiative, 2, archived_at: DateTime.now, owner_group: group) }

    it 'returns archived_initiatives' do
      expect(Initiative.archived_initiatives(enterprise)).to eq archived_initiatives
    end
  end

  describe '.archive_expired_events' do
    let!(:group) { create(:group) }
    let!(:initiative) { create(:initiative, owner_group: group) }
    let!(:expired_initiatives) { create_list(:initiative, 2, start: DateTime.now.weeks_ago(4), end: DateTime.now.weeks_ago(3), owner_group: group) }

    it 'does not archive any event when group auto archive is off' do
      expect { Initiative.archive_expired_events(group) }.to change(Initiative.where.not(archived_at: nil), :count).by(0)
    end

    it 'archives expired events' do
      group.update auto_archive: true, expiry_age_for_events: 2, unit_of_expiry_age: 'weeks'
      expect { Initiative.archive_expired_events(group) }.to change(Initiative.where.not(archived_at: nil), :count).by(2)
    end
  end

  describe 'Initiative.to_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create :group, :without_outcomes, enterprise: enterprise, annual_budget: 10000 }
    let!(:annual_budget) { create(:annual_budget, group: group, amount: group.annual_budget) }
    let!(:budget) { create(:approved_budget, annual_budget_id: annual_budget.id) }
    let!(:outcome) { create :outcome, group_id: group.id }
    let!(:pillar) { create :pillar, outcome_id: outcome.id }
    let!(:initiative) { create(:initiative, pillar: pillar,
                                            owner_group: group,
                                            estimated_funding: budget.budget_items.first.available_amount,
                                            budget_item_id: budget.budget_items.first.id)
    }
    let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, amount: 50) }

    let!(:field) { create(:field, field_definer: initiative, title: 'Attendance') }
    let!(:update) { create(:update, updatable: initiative, data: "{\"#{field.id}\":105}") }

    it 'returns csv for initiative export' do
      expect(described_class.to_csv(initiatives: group.initiatives, enterprise: enterprise))
      .to include "#{enterprise.custom_text.send('erg_text')},#{enterprise.custom_text.send('outcome_text')},#{enterprise
                     .custom_text.send('program_text')},Event Name,Start Date,End Date,Expenses,Budget,Metrics"
    end

    it 'returns csv to include metrics' do
      expect(described_class.to_csv(initiatives: group.initiatives, enterprise: enterprise))
      .to include 'Attendance(105)'
    end
  end
end
