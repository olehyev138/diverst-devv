require 'rails_helper'

RSpec.describe NumericField, type: :model do
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

  describe '#serialize_value' do
    it 'returns int' do
      value = NumericField.new.serialize_value('1')
      expect(value).to eq(1)
    end
  end

  describe '#match_score_between' do
    it 'returns 0.0' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":2}", enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{numeric_field.id}\":2}", enterprise: enterprise)
      create_list(:user, 8, data: "{\"#{numeric_field.id}\":1}", enterprise: enterprise)
      match_score_between = numeric_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(0.0)
    end
  end
end
