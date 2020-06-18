require 'rails_helper'

RSpec.describe GroupField, type: :model do
  let(:group_field) { build_stubbed(:group_field) }

  it { expect(group_field).to belong_to(:group) }
  it { expect(group_field).to belong_to(:field) }
end
