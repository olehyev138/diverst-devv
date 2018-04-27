require 'rails_helper'

RSpec.describe YammerFieldMapping, type: :model do
   let(:yammer_field_mapping) { create(:yammer_field_mapping) }

   describe 'associations' do
     it { expect(yammer_field_mapping).to belong_to(:enterprise) }
     it { expect(yammer_field_mapping).to belong_to(:diverst_field).class_name('Field') }
   end
end
