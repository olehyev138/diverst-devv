require 'rails_helper'

RSpec.describe NumericField, type: :model do
  describe 'operators' do
    let(:operators) {  NumericField.new.operators }

    it 'includes equals' do
      expect(operators).to include Field::OPERATORS[:equals]
    end

    it 'includes is_not' do
      expect(operators).to include Field::OPERATORS[:is_not]
    end

    it 'includes greater_than_excl' do
      expect(operators).to include Field::OPERATORS[:greater_than_excl]
    end

    it 'includes lesser_than_excl' do
      expect(operators).to include Field::OPERATORS[:lesser_than_excl]
    end

    it 'includes greater_than_incl' do
      expect(operators).to include Field::OPERATORS[:greater_than_incl]
    end

    it 'includes lesser_than_incl' do
      expect(operators).to include Field::OPERATORS[:lesser_than_incl]
    end
  end

  describe '#string_value' do
    it 'returns nil' do
      value = NumericField.new.string_value(nil)
      expect(value).to eq('-')
    end

    it 'returns string' do
      value = NumericField.new.string_value('1')
      expect(value).to eq('1')
    end
  end

  describe '#deserialize_value' do
    it 'returns int' do
      value = NumericField.new.deserialize_value('1')
      expect(value).to eq(1)
    end
  end

  describe '#match_score_between' do
    it 'returns 0.0' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, field_definer: enterprise)
      numeric_field.save!
      enterprise.reload
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":2}", enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{numeric_field.id}\":2}", enterprise: enterprise)
      users = create_list(:user, 8, data: "{\"#{numeric_field.id}\":1}", enterprise: enterprise)

      [user_2, user_1].map { |user| user[numeric_field] = 2 }
      users.map { |user| user[numeric_field] = 1 }

      match_score_between = numeric_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(0.0)
    end
  end
end
