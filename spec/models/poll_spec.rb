require 'rails_helper'

RSpec.describe Poll, type: :model do
  it_behaves_like 'it Defines Fields'

  describe 'when validating' do
    let(:poll) { build(:poll) }

    context 'test associations' do
      it { expect(poll).to belong_to(:enterprise).inverse_of(:polls).counter_cache(true) }
      it { expect(poll).to belong_to(:owner).class_name('User') }
      it { expect(poll).to belong_to(:initiative) }

      it { expect(poll).to have_many(:segments).inverse_of(:polls).through(:polls_segments) }
      it { expect(poll).to have_many(:groups).through(:groups_polls) }

      it { expect(poll).to have_many(:fields).dependent(:destroy) }
      it { expect(poll).to have_many(:responses).class_name('PollResponse').inverse_of(:poll).dependent(:destroy) }
      it { expect(poll).to have_many(:graphs).dependent(:destroy) }
      it { expect(poll).to have_many(:polls_segments).dependent(:destroy) }
      it { expect(poll).to have_many(:groups_polls).dependent(:destroy) }
      it { expect(poll).to have_many(:groups).inverse_of(:polls).through(:groups_polls) }
      it { expect(poll).to accept_nested_attributes_for(:fields).allow_destroy(true) }
    end

    context 'test validation' do
      it { expect(poll).to validate_presence_of(:title) }
      it { expect(poll).to validate_presence_of(:description) }
      it { expect(poll).to validate_presence_of(:status) }
      it { expect(poll).to validate_presence_of(:enterprise) }
      it { expect(poll).to validate_presence_of(:owner) }

      [:title, :description, :status, :enterprise, :owner].each do |attribute|
        it { expect(poll).to validate_presence_of(attribute) }
      end

      it { expect(poll).to validate_length_of(:description).is_at_most(65535) }
      it { expect(poll).to validate_length_of(:title).is_at_most(191) }
    end

    it { expect(poll).to define_enum_for(:status).with([:published, :draft]) }

    context 'enterprise_id of groups' do
      let(:poll) { build(:poll) }

      it 'should be invalid when there is groups of another enterprises' do
        group = create(:group, enterprise: create(:enterprise))
        poll.groups << [group]
        poll.valid?

        expect(poll.errors.messages).to have_key(:groups)
      end

      it 'should be valid when there is no groups of another enterprises' do
        group = build(:group, enterprise: poll.enterprise)
        poll.groups << [group]
        poll.valid?

        expect(poll.errors.messages).to_not have_key(:groups)
      end
    end

    context 'enterprise_id of segments' do
      let(:poll) { build(:poll) }

      it 'should be invalid when there is segments of another enterprises' do
        segment = create(:segment, enterprise: create(:enterprise))
        poll.segments << [segment]
        poll.valid?

        expect(poll.errors.messages).to have_key(:segments)
      end

      it 'should be valid when there is no segments of another enterprises' do
        segment = create(:segment, enterprise: poll.enterprise)
        poll.segments << [segment]
        poll.valid?

        expect(poll.errors.messages).to_not have_key(:segments)
      end
    end

    context 'enterprise_id of initiative' do
      let(:enterprise) { create(:enterprise) }
      let(:poll) { build(:poll, enterprise: enterprise, initiative: initiative) }

      context 'when enterprise_id of initiative and poll are not the same' do
        let(:group) { create(:group) }
        let!(:initiative) { create(:initiative, owner_group_id: group.id) }

        it 'should be invalid' do
          poll.valid?
          expect(poll.errors.messages).to have_key(:initiative)
        end
      end

      context 'when enterprise_id of initiative and poll are the same' do
        let(:pillar) { create(:pillar, outcome: outcome) }
        let(:outcome) { create(:outcome, group: group) }
        let(:group) { create(:group, enterprise: enterprise) }
        let!(:initiative) { create(:initiative, owner_group_id: group.id, pillar: pillar) }

        it 'should be valid' do
          poll.valid?
          expect(poll.errors.messages).to_not have_key(:initiative)
        end
      end
    end

    context 'validate configuration of associated objects' do
      let(:enterprise) { create(:enterprise) }
      let(:segment) { create(:segment, enterprise: enterprise) }
      let(:group) { create(:group, enterprise: enterprise) }
      let(:pillar) { create(:pillar, outcome: outcome) }
      let(:outcome) { create(:outcome, group: group) }
      let!(:initiative) { create(:initiative, owner_group_id: group.id, pillar: pillar) }

      context 'when poll have groups and segments' do
        let(:poll) { build(:poll, enterprise: enterprise, groups: [group], segments: [segment]) }

        it 'should be valid' do
          expect(poll).to be_valid
        end
      end

      context 'when poll have initiative' do
        let(:poll) { build(:poll, enterprise: enterprise, initiative: initiative) }

        it 'should be valid' do
          expect(poll).to be_valid
        end
      end

      context 'when poll have groups, segments and initiatives' do
        let(:poll) { build(:poll, enterprise: enterprise, groups: [group], segments: [segment], initiative: initiative) }

        it 'should be invalid' do
          poll.valid?
          expect(poll.errors.messages).to have_key(:associated_objects)
        end
      end
    end
  end

  context 'validate poll with fields' do
    let(:poll) { build(:poll) }

    it 'should be valid' do
      expect(poll).to be_valid
    end
  end

  describe 'test callbacks' do
    let!(:poll) { build(:poll) }

    context 'after_create' do
      # TODO: callback issue
      xit '#create_default_graphs should be called after create' do
        expect(poll).to receive(:create_default_graphs)
        poll.run_callbacks(:create)
      end
    end

    context 'before_destroy' do
      it 'run before_destroy callback successfully' do
        expect(poll).to receive(:remove_associated_fields)
        poll.run_callbacks(:destroy)
      end

      it 'deletes associated fields if any' do
        poll.save
        create(:field, field_definer: poll)
        expect { poll.reload.destroy }.to change(Field.where(field_definer: poll), :count).by(-2)
      end
    end
  end

  describe 'enumerates' do
    context 'status' do
      it { expect(Poll.statuses[:published]).to eq 0 }
      it { expect(Poll.statuses[:draft]).to eq 1 }
    end
  end

  describe 'targeted_users' do
    let!(:enterprise) { create(:enterprise) }
    let!(:poll) { create(:poll, enterprise: enterprise) }
    let!(:user) { create(:user, enterprise: poll.enterprise) }

    it 'returns only users of same enterprise of poll' do
      expect(poll.targeted_users).to eq [user]
    end

    context 'with segments' do
      let!(:user_in_segment) { create(:user, enterprise: poll.enterprise) }
      let!(:user_not_in_segment) { create(:user, enterprise: poll.enterprise) }
      let!(:segment) { create(:segment, members: [user_in_segment]) }
      before(:each) { poll.update(segments: [segment]) }

      it 'returns users that are in segments of poll segments' do
        expect(poll.targeted_users).to include user_in_segment
        expect(poll.targeted_users).to_not include user_not_in_segment
      end
    end

    context 'with groups' do
      let!(:user_in_group) { create(:user, enterprise: poll.enterprise) }
      let!(:pending_user_in_group) { create(:user, enterprise: poll.enterprise) }
      let!(:group) { create(:group, members: [user_in_group, pending_user_in_group]) }

      before {
        # add and accept members here. check they work
        group.update(pending_users: 'enabled')

        group.accept_user_to_group(user_in_group.id)
      }
      before(:each) { poll.update(groups: [group]) }

      it 'returns users that are in groups of poll groups' do
        expect(poll.targeted_users).to include user_in_group
        expect(poll.targeted_users).to_not include pending_user_in_group
      end
    end
  end

  describe '#graphs_population' do
    it 'returns the graphs_population' do
      enterprise = create(:enterprise)
      user = build(:user)
      poll = create(:poll, enterprise: enterprise, owner: user)
      select_field = poll.fields.find_by(title: 'What is 1 + 1?')
      create(:poll_response, poll: poll, user: user, data: "{\"#{select_field.id}\":[\"4\"]}")

      users = poll.graphs_population
      expect(users.count).to eq(1)
    end
  end

  describe '#responses_csv' do
    it 'returns the responses_csv' do
      enterprise = create(:enterprise)
      user_1 = build(:user)
      user_2 = build(:user)
      poll = create(:poll, enterprise: enterprise, owner: user_1)

      select_field = poll.fields.last

      pr1 = create(:poll_response, poll: poll, user: user_1, data: "{\"#{select_field.id}\":[\"4\"]}")
      pr2 = create(:poll_response, poll: poll, user: user_2, data: "{\"#{select_field.id}\":[\"4\"]}", created_at: 10.minutes.ago)

      pr1[select_field] = ['4']
      pr2[select_field] = ['4']

      user_2.destroy

      poll.reload

      expect(poll.responses_csv).to eq("user_id,user_email,user_name,What is 1 + 1?\n#{user_1.id},#{user_1.email},#{user_1.name},4\n\"\",\"\",Deleted User,4\n")
    end
  end

  describe '#can_be_saved_as_draft?' do
    it 'return true if new record' do
      poll = build(:poll)
      expect(poll.can_be_saved_as_draft?).to eq(true)
    end

    it 'returns true if draft' do
      poll = create(:poll, status: 1)
      expect(poll.can_be_saved_as_draft?).to eq(true)
    end
  end

  describe '#graphable_fields' do
    let(:user) { create(:user) }
    let(:poll) { create(:poll, enterprise_id: user.enterprise.id) }

    it 'returns enterprise fields' do
      expect(poll.graphable_fields(user)).to eq user.enterprise.fields + poll.fields
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      poll = create(:poll)
      field = create(:field, field_definer: poll)
      response = create(:poll_response, poll: poll)
      graph = create(:graph, poll: poll)
      polls_segment = create(:polls_segment, poll: poll)
      groups_poll = create(:groups_poll, poll: poll)

      poll.destroy

      expect { Poll.find(poll.id) }.to raise_error(ActiveRecord::RecordNotFound)
      # expect{Field.find(field.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect { PollResponse.find(response.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Graph.find(graph.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { PollsSegment.find(polls_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupsPoll.find(groups_poll.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
