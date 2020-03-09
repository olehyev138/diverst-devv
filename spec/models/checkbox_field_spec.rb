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
      user_2[checkbox_field] = ['Mandarin']

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
      user[checkbox_field] = ['English']

      popularity = checkbox_field.popularity_for_value('English', [user])
      expect(popularity).to eq(1)
    end

    it 'returns 0.5' do
      enterprise = create(:enterprise)
      checkbox_field = create(:checkbox_field, title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese")
      enterprise.fields << checkbox_field
      user_1 = create(:user, data: "{\"#{checkbox_field.id}\":[\"English\"]}", enterprise: enterprise)
      user_1[checkbox_field] = ['English']
      user_2 = create(:user, data: "{\"#{checkbox_field.id}\":[\"Spanish\"]}", enterprise: enterprise)
      user_2[checkbox_field] = ['Spanish']

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
      user_1[checkbox_field] = ['English']
      user_1[checkbox_field] = ['English']
      users = create_list(:user, 9, data: "{\"#{checkbox_field.id}\":[\"Spanish\"]}", enterprise: enterprise)
      users.each { |user| user[checkbox_field] = ['Spanish'] }

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
      user_1[checkbox_field] = ['English']
      user_1[checkbox_field] = ['English']
      user_2 = create(:user, data: "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", enterprise: enterprise)
      user_2[checkbox_field] = ['Mandarin']
      user_2[checkbox_field] = ['Mandarin']
      users = create_list(:user, 8, data: "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", enterprise: enterprise)
      users.each { |user| user[checkbox_field] = ['Mandarin'] }

      match_score_between = checkbox_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(0.8)
    end
  end

  describe '#validates_rule_for_user' do
    it 'return false if user has no info' do
      user = create(:user)
      checkbox_field = CheckboxField.new(type: 'CheckboxField', title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", enterprise: user.enterprise)
      checkbox_field.save!
      rule = create(:segment_rule)

      expect(checkbox_field.validates_rule_for_user?(rule: rule, user: user)).to eq(false)
    end

    it 'returns true if user has info' do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(type: 'CheckboxField', title: 'Spoken languages', options_text: "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", enterprise: enterprise)
      checkbox_field.save!
      user = create(:user, data: "{\"#{checkbox_field.id}\":[\"English\"]}", enterprise: enterprise)
      segment = create(:segment, name: 'Languages', enterprise: enterprise)
      rule = create(:segment_rule, field_id: checkbox_field.id, segment_id: segment.id, operator: 4, values: '["English"]')

      expect(checkbox_field.validates_rule_for_user?(rule: rule, user: user)).to eq(true)
    end
  end
end
