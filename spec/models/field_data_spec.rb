require 'rails_helper'

RSpec.describe FieldData, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe 'when validating' do
    let(:field_data) { build(:field_data) }

    describe 'test associations and validations' do
      it { expect(field_data).to belong_to(:field_user) }
      it { expect(field_data).to belong_to(:field) }
      it { expect(field_data).to validate_presence_of(:field_user) }
      it { expect(field_data).to validate_presence_of(:field) }
    end
  end
end
