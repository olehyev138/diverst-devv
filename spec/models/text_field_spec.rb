require 'rails_helper'

RSpec.describe TextField, type: :model do
  describe '#validates_rule_for_user' do
    it 'returns true' do
      enterprise = create(:enterprise)
      text_field = TextField.new(type: 'TextField', title: 'Current Title', enterprise: enterprise)
      text_field.save!
      user_1 = create(:user, data: "{\"#{text_field.id}\": \"Customer Service Representative\"}", enterprise: enterprise)
      segment = create(:segment, name: 'Customer Service Reps', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: text_field.id, operator: 0, values: '["Customer Service Representative"]')
      boolean = text_field.validates_rule_for_user?(rule: segment_rule, user: user_1)

      expect(boolean).to be(true)
    end

    it 'returns false' do
      enterprise = create(:enterprise)
      text_field = TextField.new(type: 'TextField', title: 'Current Title', enterprise: enterprise)
      text_field.save!
      user_1 = create(:user, data: "{\"#{text_field.id}\": \"Customer Service Representative\"}", enterprise: enterprise)
      segment = create(:segment, name: 'Engineers', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: text_field.id, operator: 4, values: '["Engineer"]')
      boolean = text_field.validates_rule_for_user?(rule: segment_rule, user: user_1)

      expect(boolean).to be(false)
    end

    it 'returns true' do
      enterprise = create(:enterprise)
      text_field = TextField.new(type: 'TextField', title: 'Current Title', enterprise: enterprise)
      text_field.save!
      user_1 = create(:user, data: "{\"#{text_field.id}\": \"Customer Service Representative\"}", enterprise: enterprise)
      segment = create(:segment, name: 'Engineers', enterprise: enterprise)
      segment_rule = create(:segment_rule, segment_id: segment.id, field_id: text_field.id, operator: 6, values: '["Engineer"]')
      boolean = text_field.validates_rule_for_user?(rule: segment_rule, user: user_1)

      expect(boolean).to be(true)
    end
  end
end
