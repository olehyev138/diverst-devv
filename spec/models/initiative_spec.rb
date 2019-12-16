require 'rails_helper'

RSpec.describe Initiative, type: :model do
  include ActiveJob::TestHelper

  describe 'when validating' do
    let(:initiative) { build(:initiative) }

    it { expect(initiative).to belong_to(:pillar) }
    it { expect(initiative).to belong_to(:owner).class_name('User') }
    it { expect(initiative).to have_many(:updates).class_name('InitiativeUpdate').dependent(:destroy) }
    it { expect(initiative).to have_many(:fields).dependent(:delete_all) }
    it { expect(initiative).to have_many(:expenses).dependent(:destroy).class_name('InitiativeExpense') }

    it { expect(initiative).to accept_nested_attributes_for(:fields).allow_destroy(true) }

    it { expect(initiative).to belong_to(:budget_item) }
    it { expect(initiative).to have_one(:budget).through(:budget_item) }

    it { expect(initiative).to have_many(:checklists) }
    it { expect(initiative).to have_many(:resources) }

    it { expect(initiative).to have_many(:checklist_items) }
    it { expect(initiative).to accept_nested_attributes_for(:checklist_items).allow_destroy(true) }

    it { expect(initiative).to belong_to(:owner_group).class_name('Group') }

    it { expect(initiative).to have_many(:initiative_segments) }
    it { expect(initiative).to have_many(:segments).through(:initiative_segments) }
    it { expect(initiative).to have_many(:initiative_participating_groups) }
    it { expect(initiative).to have_many(:participating_groups).through(:initiative_participating_groups).source(:group).class_name('Group') }

    it { expect(initiative).to have_many(:initiative_invitees) }
    it { expect(initiative).to have_many(:invitees).through(:initiative_invitees).source(:user) }
    it { expect(initiative).to have_many(:comments).class_name('InitiativeComment') }

    it { expect(initiative).to have_many(:initiative_users) }
    it { expect(initiative).to have_many(:attendees).through(:initiative_users).source(:user) }

    # ActiveStorage
    it { expect(initiative).to have_attached_file(:picture) }
    it { expect(initiative).to validate_attachment_content_type(:picture, AttachmentHelper.common_image_types) }

    it { expect(initiative).to validate_presence_of(:start) }
    it { expect(initiative).to validate_presence_of(:end) }
    it { expect(initiative).to validate_presence_of(:pillar) }
    it { expect(initiative).to validate_numericality_of(:max_attendees).is_greater_than(0).allow_nil }
    it { expect(initiative).to have_many(:resources) }
    it { expect(initiative).to have_many(:segments).through(:initiative_segments) }
    it { expect(initiative).to have_one(:outcome).through(:pillar) }

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

  describe 'test callbacks' do
    let!(:new_initiative) { build(:initiative) }

    it '#allocate_budget_funds' do
      expect(new_initiative).to receive(:allocate_budget_funds)
      new_initiative.save
    end
  end

  describe '.recent' do
    let!(:past_initiative) { create(:initiative, created_at: 61.days.ago) }
    let!(:recent_initiative) { create(:initiative, created_at: 1.day.ago) }

    it 'return initiatives created in the last 60 days' do
      expect(Initiative.recent).to eq [recent_initiative]
    end
  end

  describe '.of_segments' do
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

          it 'marks budget item as done' do
            expect(initiative.budget_item.is_done).to eq true
          end
        end
      end

      context 'with leftover money' do
        before { group.leftover_money = 1000 }

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

  describe '#expenses_status' do
    it 'returns Expenses in progress' do
      initiative = build(:initiative)
      expect(initiative.expenses_status).to eq('Expenses in progress')
    end

    it 'returns Expenses in progress' do
      initiative = build(:initiative, finished_expenses: true)
      expect(initiative.expenses_status).to eq('Expenses finished')
    end
  end

  describe '#approved?' do
    it 'returns false' do
      budget = build(:budget, is_approved: true)
      budget_item = create(:budget_item, budget: budget)
      initiative = create(:initiative, budget_item_id: budget_item.id)

      expect(initiative.approved?).to eq(false)
    end

    it 'returns true' do
      budget = build(:budget)
      budget_item = create(:budget_item, budget: budget)
      initiative = create(:initiative, budget_item_id: budget_item.id)

      expect(initiative.approved?).to eq(true)
    end

    it 'returns true' do
      initiative = build(:initiative)
      expect(initiative.approved?).to eq(true)
    end
  end

  describe '#leftover' do
    it 'returns 0' do
      initiative = build(:initiative, annual_budget: build(:annual_budget))
      expect(initiative.leftover).to eq(0)
    end
  end

  describe '#highcharts_history' do
    it 'returns data', skip: 'test fails' do
      initiative = build(:initiative, start: Date.today, end: Date.today + 1.hour)
      field = build(:field)
      create(:initiative_field, initiative: initiative, field: field)
      create(:initiative_update, initiative: initiative)

      data = initiative.highcharts_history(field: field)
      expect(data.empty?).to be(false) # this example says "returns data" and yet we expect data to be empty???
    end
  end

  describe '#expenses_highcharts_history' do
    it 'returns data' do
      group = create(:group, annual_budget: 10000)
      annual_budget = create(:annual_budget, amount: group.annual_budget)
      initiative = create(:initiative, owner_group: group, annual_budget_id: annual_budget.id, start: Date.today, end: Date.today + 1.hour)
      create_list(:initiative_expense, 5, initiative: initiative, annual_budget_id: annual_budget.id)

      data = initiative.expenses_highcharts_history
      expect(data.empty?).to be(false)
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

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      group = create(:group, annual_budget: 10000)
      annual_budget = create(:annual_budget, amount: group.annual_budget)
      initiative = create(:initiative, owner_group_id: group.id, annual_budget_id: annual_budget.id)
      initiative_update = create(:initiative_update, initiative: initiative)
      field = create(:field, initiative: initiative)
      initiative_expense = create(:initiative_expense, initiative: initiative, annual_budget_id: annual_budget.id)
      checklist = create(:checklist, initiative: initiative)
      resource = create(:resource, initiative: initiative)
      checklist_item = create(:checklist_item, initiative: initiative)
      initiative_segment = create(:initiative_segment, initiative: initiative)
      initiative_participating_group = create(:initiative_participating_group, initiative: initiative)
      initiative_invitee = create(:initiative_invitee, initiative: initiative)
      initiative_comment = create(:initiative_comment, initiative: initiative)
      initiative_user = create(:initiative_user, initiative: initiative)

      initiative.destroy!

      expect { Initiative.find(initiative.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InitiativeUpdate.find(initiative_update.id) }.to raise_error(ActiveRecord::RecordNotFound)
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

  describe '#unfinished_expenses?' do
    let!(:initiative) { create(:initiative, start: DateTime.now.days_ago(3), end: DateTime.now.days_ago(1),
                                            finished_expenses: false)
    }

    it 'returns true for #unfinished_expenses?' do
      expect(initiative.unfinished_expenses?).to eq true
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
    let!(:annual_budget) { create(:annual_budget, group: group, amount: group.annual_budget, enterprise_id: enterprise.id) }
    let!(:budget) { create(:approved_budget, group_id: group.id, annual_budget_id: annual_budget.id) }
    let!(:outcome) { create :outcome, group_id: group.id }
    let!(:pillar) { create :pillar, outcome_id: outcome.id }
    let!(:initiative) { create(:initiative, pillar: pillar,
                                            owner_group: group,
                                            annual_budget_id: annual_budget.id,
                                            estimated_funding: budget.budget_items.first.available_amount,
                                            budget_item_id: budget.budget_items.first.id)
    }
    let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, annual_budget_id: annual_budget.id, amount: 50) }

    let!(:field) { create(:field, initiative_id: initiative.id, title: 'Attendance') }
    let!(:update) { create(:initiative_update, initiative_id: initiative.id, data: "{\"#{field.id}\":105}") }


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
