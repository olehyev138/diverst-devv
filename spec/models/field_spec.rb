require 'rails_helper'

RSpec.describe Field do
  describe 'when validating' do
    let(:field) { build(:field, field_definer: build(:enterprise)) }
    let(:field1) { build(:field, field_definer: build(:enterprise)) }

    context 'validate presence of title for field' do
      it 'valid if title is present' do
        field.title = 'title'
        expect(field).to be_valid
      end

      it 'invalid if title is absent' do
        field.title = ''
        expect(field).not_to be_valid
      end
    end

    context 'validate presence of type for field' do
      it 'valid if type is present' do
        field.type = 'TextField'
        expect(field).to be_valid
      end

      it 'invalid if type is absent' do
        field.type = ''
        expect(field).not_to be_valid
      end
    end

    context 'validate inclusion of type for field' do
      it 'valid if type is present' do
        field.type = 'TextField'
        expect(field).to be_valid
      end

      it 'invalid if type is fake field' do
        field.type = 'TestField'
        expect(field).not_to be_valid
      end
    end

    context 'validate presence of title for field1' do
      it 'valid if title is present' do
        field1.title = 'title'
        expect(field1).to be_valid
      end

      it 'valid if title is absent' do
        field1.title = ''
        expect(field1).not_to be_valid
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
