require 'rails_helper'

RSpec.describe SelectField, type: :model do
  describe '#string_value' do
    it 'returns nil' do
      value = SelectField.new.string_value(nil)
      expect(value).to eq('-')
    end

    it 'returns nil' do
      value = SelectField.new.string_value('')
      expect(value).to eq('-')
    end

    it 'returns nil' do
      value = SelectField.new.string_value([])
      expect(value).to eq('-')
    end

    it 'returns Female' do
      value = SelectField.new.string_value(['Female'])
      expect(value).to eq('Female')
    end
  end

  describe '#csv_value' do
    it 'returns nil' do
      value = SelectField.new.csv_value(nil)
      expect(value).to eq('')
    end

    it 'returns nil' do
      value = SelectField.new.csv_value('')
      expect(value).to eq('')
    end

    it 'returns nil' do
      value = SelectField.new.csv_value([])
      expect(value).to eq('')
    end

    it 'returns Female' do
      value = SelectField.new.csv_value(['Female'])
      expect(value).to eq('Female')
    end
  end

  describe '#popularity_for_value' do
    it 'returns 1' do
      enterprise = create(:enterprise)
      select_field = create(:select_field, title: 'Gender', options_text: "Male\nFemale")
      enterprise.fields << select_field
      user = create(:user, data: "{\"#{select_field.id}\":[\"Female\"]}", enterprise: enterprise)
      user[select_field] = ['Female']

      popularity = select_field.popularity_for_value('Female', [user])
      expect(popularity).to eq(1)
    end

    it 'returns 0.5' do
      enterprise = create(:enterprise)
      select_field = create(:select_field, title: 'Gender', options_text: "Male\nFemale")
      enterprise.fields << select_field
      user_1 = create(:user, data: "{\"#{select_field.id}\":[\"Female\"]}", enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{select_field.id}\":[\"Male\"]}", enterprise: enterprise)

      user_1[select_field] = ['Male']
      user_2[select_field] = ['Female']

      popularity = select_field.popularity_for_value('Female', [user_1, user_2])
      expect(popularity).to eq(0.5)
    end
  end

  describe '#match_score_between' do
    it 'returns 0.5' do
      enterprise = create(:enterprise)
      select_field = create(:select_field, title: 'Gender', options_text: "Male\nFemale")
      enterprise.fields << select_field

      user_1 = create(:user, data: "{\"#{select_field.id}\":[\"Female\"]}", enterprise: enterprise)
      user_2 = create(:user, data: "{\"#{select_field.id}\":[\"Male\"]}", enterprise: enterprise)
      users = create_list(:user, 8, data: "{\"#{select_field.id}\":[\"Male\"]}", enterprise: enterprise)

      ([user_2] + users).each { |user| user[select_field] = ['Male'] }
      user_1[select_field] = ['Female']

      match_score_between = select_field.match_score_between(user_1, user_2, [user_1, user_2])
      expect(match_score_between).to eq(0.5)
    end
  end

  describe '#answer_popularities' do
    it 'returns the count for each poll option' do
      enterprise = create(:enterprise)
      user = create(:user)
      poll = create(:poll, enterprise: enterprise, owner: user)
      select_field = poll.fields.find_by(title: 'What is 1 + 1?')
      select_field.save!
      poll_response = create(:poll_response, poll: poll, user: user, data: "{\"#{select_field.id}\":[\"4\"]}")
      poll_response[select_field] = ['4']

      answer_popularities = select_field.answer_popularities(entries: poll.responses)
      expect(answer_popularities).to eq([{ answer: '1', count: 0 }, { answer: '2', count: 0 }, { answer: '3', count: 0 },
                                         { answer: '4', count: 1 }, { answer: '5', count: 0 }, { answer: '6', count: 0 }, { answer: '7', count: 0 }])
    end
  end
end
