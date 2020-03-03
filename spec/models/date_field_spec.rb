require 'rails_helper'

RSpec.describe DateField, type: :model do
  describe 'operators' do
    let(:operators) {  DateField.new.operators }

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
      value2 = DateField.new.deserialize_value(date.to_f)
      expect(value).to eq(Time.at(date))
      expect((value2 - Time.at(date)).abs).to be < 1e-6
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
      date_field = DateField.new(type: 'DateField', title: 'Date of birth', field_definer: enterprise)
      date_field.save!
      enterprise.reload
      user_1 = create(:user, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      users = create_list(:user, 8, data: "{\"#{date_field.id}\":-1641600}", enterprise: enterprise)
      ([user_2, user_1] + users).map { |user| user[date_field] = -1641600 }

      match_score_between = date_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(nil)
    end
  end
end
