require 'rails_helper'

RSpec.describe DateField, type: :model do
  describe '#string_value' do
    it 'returns nil' do
      value = DateField.new.string_value(nil)
      expect(value).to eq('-')
    end
  end

  describe '#process_field_value' do
    it 'returns nil' do
      value = DateField.new.process_field_value('')
      expect(value).to be(nil)
    end

    it 'returns formatted date' do
      date = '2017-11-01'
      value = DateField.new.process_field_value(date)
      expect(value).to eq(Time.strptime(date, '%F'))
    end
  end

  describe '#deserialize_value' do
    it 'returns nil' do
      value = DateField.new.deserialize_value(nil)
      expect(value).to be(nil)
    end

    it 'returns date' do
      date = DateTime.now
      value = DateField.new.deserialize_value(date)
      expect(value).to eq(Time.at(date))
    end
  end

  describe '#csv_value' do
    it 'returns nil' do
      value = DateField.new.csv_value(nil)
      expect(value).to eq('')
    end

    it 'returns date' do
      date = DateTime.now
      value = DateField.new.csv_value(date)
      expect(value).to eq(date.strftime('%F'))
    end
  end

  describe '#match_score_between' do
    it 'returns nil' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      create_list(:user, 8, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      match_score_between = date_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(nil)
    end
  end

  describe '#validates_rule_for_user' do
    it 'returns true' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 1, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 1, data: '["1998-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-60307200}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 0, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-60220800}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 0, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-691372800}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 2, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":886550400}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 2, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":886550400}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 3, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', enterprise: enterprise)
      date_field.save!
      user_1 = create(:user, data: "{\"#{date_field.id}\":-60307200}", enterprise: enterprise)
      segment = create(:segment, name: 'Seniors', enterprise: enterprise)
      segment_field_rule = create(:segment_field_rule, segment_id: segment.id, field_id: date_field.id, operator: 3, data: '["1968-02-03"]')
      boolean = date_field.validates_rule_for_user?(rule: segment_field_rule, user: user_1)

      expect(boolean).to be(false)
    end
  end
end
