require 'rails_helper'

RSpec.describe YammerFieldMapping, type: :model do
  let(:yammer_field_mapping) { build_stubbed(:yammer_field_mapping) }

  describe 'associations' do
    it { expect(yammer_field_mapping).to belong_to(:enterprise) }
    it { expect(yammer_field_mapping).to belong_to(:diverst_field).class_name('Field') }
    it { expect(yammer_field_mapping).to validate_length_of(:yammer_field_name).is_at_most(191) }
  end
end