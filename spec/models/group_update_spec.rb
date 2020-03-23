require 'rails_helper'

RSpec.describe GroupUpdate, type: :model do
  it_behaves_like 'it Contains Field Data'

  describe 'test associations and validations' do
    let(:group_update) { build_stubbed(:group_update) }

    it { expect(group_update).to belong_to(:owner).class_name('User') }
    it { expect(group_update).to belong_to(:group) }

    it { expect(group_update).to validate_presence_of(:created_at) }
    it { expect(group_update).to validate_length_of(:comments).is_at_most(65535) }
  end
end
