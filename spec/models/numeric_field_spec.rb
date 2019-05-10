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

  describe '#validates_rule_for_user' do
    it 'returns true' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":21}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 1, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":19}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 1, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":20}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 0, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":19}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 0, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":19}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 2, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":21}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 2, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":19}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 3, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(type: 'NumericField', title: 'Seniority (in years)', min: 0, max: 40, enterprise: enterprise)
      numeric_field.save!
      user_1 = create(:user, data: "{\"#{numeric_field.id}\":20}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: numeric_field.id, operator: 3, values: '["20"]')
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end
  end
end
