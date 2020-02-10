require 'rails_helper'

RSpec.describe Field do
  describe 'when validating' do
    let(:field) { build(:field, enterprise: build(:enterprise)) }
    let(:field1) { build(:field, enterprise: build(:enterprise)) }

    describe 'test associations' do
      it { expect(field).to belong_to(:enterprise) }
      it { expect(field).to belong_to(:group) }
      it { expect(field).to belong_to(:poll) }
      it { expect(field).to belong_to(:initiative) }

      it { expect(field).to have_many(:yammer_field_mappings).with_foreign_key(:diverst_field_id) }
    end

    describe 'test validation' do
      it { expect(field).to validate_length_of(:field_type).is_at_most(191) }
      it { expect(field).to validate_length_of(:options_text).is_at_most(65535) }
      it { expect(field).to validate_length_of(:saml_attribute).is_at_most(191) }
      it { expect(field).to validate_length_of(:title).is_at_most(191) }
      it { expect(field).to validate_length_of(:type).is_at_most(191) }
      it { expect(field).to validate_presence_of(:title) }

      context 'if not group or segment type' do
        it { byebug; expect(field).to validate_uniqueness_of(:title).scoped_to(:enterprise_id) }
      end
    end

    describe '#container_type_is_enterprise?' do
      let(:field) { build(:field, enterprise: create(:enterprise)) }

      it 'returns true if container is enterprise' do
        expect(field.container_type_is_enterprise?).to eq true
      end
    end

    describe '#process_field_value' do
      it 'returns value' do
        expect(field.process_field_value('some value')).to eq('some value')
      end
    end

    describe '#serialize_value' do
      it 'returns value' do
        expect(field.serialize_value('some value')).to eq('some value')
      end
    end

    describe '#deserialize_value' do
      it 'returns value' do
        expect(field.deserialize_value('some value')).to eq('some value')
      end
    end

    describe '#string_value' do
      it 'returns value' do
        expect(field.string_value('some value')).to eq('some value')
      end
    end

    describe '#csv_value' do
      it 'returns value' do
        expect(field.csv_value('some value')).to eq('some value')
      end
    end

    describe '#graphable?' do
      let(:field) { build_stubbed(:numeric_field) }

      it 'returns true' do
        expect(field.graphable?).to eq true
      end
    end

    describe '.numeric?' do
      context 'when field is Numeric' do
        let(:field) { build_stubbed(:numeric_field) }
        let(:field1) { build_stubbed(:date_field) }

        it 'returns true for NumericField' do
          expect(field.numeric?).to eq true
        end

        it 'returns true for DateField' do
          expect(field1.numeric?).to eq true
        end
      end

      context 'when field is not Numeric' do
        let(:non_numeric_field) { build_stubbed(:select_field) }

        it 'returns false' do
          expect(non_numeric_field.numeric?).to eq false
        end
      end
    end

    describe '#format_value_name' do
      it 'returns value' do
        expect(field.format_value_name('some value')).to eq('some value')
      end
    end

    describe '#enterprise' do
      let(:enterprise) { create(:enterprise) }
      let(:field) { create(:field) }

      context 'when enterprise is present' do
        it 'returns enterprise object' do
          field.update(enterprise_id: enterprise.id)
          expect(field.enterprise).to eq(enterprise)
        end

        it 'returns enterprise when group_id is present and group is associated with that enterprise' do
          group = create(:group, enterprise: enterprise)
          field.update(group_id: group.id)
          expect(field.enterprise).to eq(group.enterprise)
        end

        it 'returns enterprise when poll_id is present and poll is associated with that enterprise' do
          poll = create(:poll, enterprise: enterprise)
          field.update(poll_id: poll.id)
          expect(field.enterprise).to eq(poll.enterprise)
        end

        it 'returns enterprise when initiative_id is present and initiative is associated with that enterprise' do
          group = create(:group, enterprise: enterprise, annual_budget: nil)
          initiative = create(:initiative, owner: nil, budget_item_id: nil, annual_budget: nil, owner_group_id: group)
          field.update(initiative_id: initiative.id)
          expect(field.enterprise).to eq(initiative.enterprise)
        end
      end
    end

    describe 'when describing callbacks' do
      let!(:field) { create(:field, enterprise: create(:enterprise)) }

      it 'should reindex users on elasticsearch after update', skip: true do
        TestAfterCommit.with_commits(true) do
          expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
            model_name: 'User',
            enterprise: field.enterprise
          )
          field.update(title: 'Field')
        end
      end

      it 'should reindex users on elasticsearch after destroy', skip: true do
        TestAfterCommit.with_commits(true) do
          expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
            model_name: 'User',
            enterprise: field.enterprise
          )
          field.destroy
        end
      end
    end

    describe '#string_value' do
      it 'Returns a well-formatted string representing the value. Used for display.' do
        field = create(:field)
        expect(field.string_value('test')).to eq('test')
      end
    end

    describe '#destroy_callbacks' do
      it 'removes the child objects' do
        field = create(:field)
        yammer_field_mapping = create(:yammer_field_mapping, diverst_field: field)

        field.destroy!

        expect { Field.find(field.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { YammerFieldMapping.find(yammer_field_mapping.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
