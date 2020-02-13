require 'rails_helper'

RSpec.describe CheckboxField, type: :model do
  describe '#string_value' do
    it 'returns nil' do
      value = CheckboxField.new.string_value(nil)
      expect(value).to eq('-')
    end

    it 'returns nil' do
      value = CheckboxField.new.string_value([])
      expect(value).to eq('')
    end

    it 'returns long string' do
      value = CheckboxField.new.string_value(['English', 'Mandarin', 'Spanish', 'Hind', 'Arabic', 'Russian'])
      expect(value).to eq('English, Mandarin, Spanish, Hind, Arabic, Russian')
    end
  end

  describe '#csv_value' do
    it 'returns nil' do
      value = CheckboxField.new.csv_value(nil)
      expect(value).to eq('')
    end

    it 'returns nil' do
      value = CheckboxField.new.csv_value([])
      expect(value).to eq('')
    end

    it 'returns long string' do
      value = CheckboxField.new.csv_value(['English', 'Mandarin', 'Spanish', 'Hind', 'Arabic', 'Russian'])
      expect(value).to eq('English,Mandarin,Spanish,Hind,Arabic,Russian')
    end
  end

  describe '#popularity_for_no_option' do
    it 'returns 1' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user = create(:user, enterprise: enterprise)

      popularity = checkbox_field.popularity_for_no_option([user])
      expect(popularity).to eq(1)
    end

    it 'returns 0.5' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user_1 = create(:user, enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", enterprise: enterprise)
      user_2.get_field_data(checkbox_field).update(data: '["Mandarin"]')

      popularity = checkbox_field.popularity_for_no_option([user_1, user_2])
      expect(popularity).to eq(0.5)
    end
  end

  describe '#popularity_for_value' do
    it 'returns 1' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user = create(:user, data: "{\"#{checkbox_field.id}\":[\"English\"]}", enterprise: enterprise)
      user.get_field_data(checkbox_field).update(data: '["English"]')

      popularity = checkbox_field.popularity_for_value('English', [user])
      expect(popularity).to eq(1)
    end

    it 'returns 0.5' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user_1 = create(:user, data: "{\"#{checkbox_field.id}\":[\"English\"]}", enterprise: enterprise)
      user_1.get_field_data(checkbox_field).update(data: '["English"]')
      user_2 = create(:user, data: "{\"#{checkbox_field.id}\":[\"Spanish\"]}", enterprise: enterprise)
      user_2.get_field_data(checkbox_field).update(data: '["Spanish"]')

      popularity = checkbox_field.popularity_for_value('English', [user_1, user_2])
      expect(popularity).to eq(0.5)
    end
  end

  describe '#user_popularity' do
    it 'returns 0.1' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user_1 = create(:user, data: "{\"#{checkbox_field.id}\":[\"English\"]}", enterprise: enterprise)
      user_1.get_field_data(checkbox_field).update(data: '["English"]')
      user_1.get_field_data(checkbox_field).update(data: '["English"]')
      users = create_list(:user, 9, data: "{\"#{checkbox_field.id}\":[\"Spanish\"]}", enterprise: enterprise)
      users.each { |user| user.get_field_data(checkbox_field).update(data: '["Spanish"]') }

      popularity = checkbox_field.user_popularity(user_1, enterprise.users)
      expect(popularity).to eq(0.1)
    end
  end

  describe '#match_score_between' do
    it 'returns 0.5' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user_1 = create(:user, data: "{\"#{checkbox_field.id}\":[\"English\"]}", enterprise: enterprise)
      user_1.get_field_data(checkbox_field).update(data: '["English"]')
      user_1.get_field_data(checkbox_field).update(data: '["English"]')
      user_2 = create(:user, data: "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", enterprise: enterprise)
      user_2.get_field_data(checkbox_field).update(data: '["Mandarin"]')
      user_2.get_field_data(checkbox_field).update(data: '["Mandarin"]')
      users = create_list(:user, 8, data: "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", enterprise: enterprise)
      users.each { |user| user.get_field_data(checkbox_field).update(data: '["Mandarin"]') }

      match_score_between = checkbox_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(0.8)
    end
  end
end
