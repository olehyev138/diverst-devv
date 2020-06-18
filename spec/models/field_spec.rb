require 'rails_helper'

RSpec.describe Field do
  describe 'when validating' do
    let(:field) { build(:field, field_definer: build(:enterprise)) }

    describe 'test associations and validations' do
      it { expect(field).to belong_to(:field_definer) }
      it { expect(field).to have_many(:field_data).class_name('FieldData').dependent(:destroy) }
      it { expect(field).to have_many(:yammer_field_mappings).with_foreign_key('diverst_field_id').dependent(:delete_all) }

      it { expect(field).to validate_presence_of(:title) }
      it { expect(field).to validate_presence_of(:type) }
      it { expect(field).to validate_presence_of(:field_definer) }

      it { expect(field).to validate_length_of(:field_type).is_at_most(191) }
      it { expect(field).to validate_length_of(:options_text).is_at_most(65535) }
      it { expect(field).to validate_length_of(:saml_attribute).is_at_most(191) }
      it { expect(field).to validate_length_of(:title).is_at_most(191) }
      it { expect(field).to validate_length_of(:type).is_at_most(191) }
      it { expect(field).to validate_inclusion_of(:type).in_array(['SelectField', 'TextField', 'SegmentsField', 'NumericField', 'GroupsField', 'CheckboxField', 'DateField']) }
      context 'unless SegmentsField, GroupsField' do
        ['SelectField', 'TextField', 'NumericField', 'CheckboxField', 'DateField'].each do |type|
          before do
            field.type = type
          end
          it { should validate_uniqueness_of(:title).scoped_to(:field_definer_id, :field_definer_type) }
        end
      end
    end
  end

  describe '.numeric?' do
    context 'when field is Numeric' do
      let(:numeric_field) { build_stubbed(:numeric_field) }

      it 'returns true' do
        expect(numeric_field.numeric?).to eq true
      end
    end

    context 'when field is not Numeric' do
      let(:non_numeric_field) { build_stubbed(:select_field) }

      it 'returns false' do
        expect(non_numeric_field.numeric?).to eq false
      end
    end
  end

  describe 'when describing callbacks' do
    let!(:field) { create(:field, field_definer: create(:enterprise)) }

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

  describe 'evaluate' do
    # TODO - test evaluate evaluates each operator correctly
    pending('TODO')
  end

  describe 'operators' do
    context 'operators should have correct ids' do
      it 'equals: 0' do
        expect(Field::OPERATORS[:equals]).to eq 0
      end

      it 'greater_than_excl: 1' do
        expect(Field::OPERATORS[:greater_than_excl]).to eq 1
      end

      it 'lesser_than: 2' do
        expect(Field::OPERATORS[:lesser_than_excl]).to eq 2
      end

      it 'is_not: 3' do
        expect(Field::OPERATORS[:is_not]).to eq 3
      end

      it 'contains_any_of: 4' do
        expect(Field::OPERATORS[:contains_any_of]).to eq 4
      end

      it 'contains_all_of: 5' do
        expect(Field::OPERATORS[:contains_all_of]).to eq 5
      end

      it 'does_not_contain: 6' do
        expect(Field::OPERATORS[:does_not_contain]).to eq 6
      end

      it 'greater_than_incl: 7' do
        expect(Field::OPERATORS[:greater_than_incl]).to eq 7
      end

      it 'lesser_than_incl: 8' do
        expect(Field::OPERATORS[:lesser_than_incl]).to eq 8
      end

      it 'equals_any_of: 9' do
        expect(Field::OPERATORS[:equals_any_of]).to eq 9
      end

      it 'not_equals_any_of: 10' do
        expect(Field::OPERATORS[:not_equals_any_of]).to eq 10
      end

      it 'is_part_of: 11' do
        expect(Field::OPERATORS[:is_part_of]).to eq 11
      end
    end
  end
end
