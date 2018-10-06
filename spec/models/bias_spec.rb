require 'rails_helper'

RSpec.describe Bias, type: :model do
  describe 'when validating' do
    let(:bias) { build_stubbed(:bias) }

    context 'test associations' do
        it { expect(bias).to belong_to(:user) }
        it { expect(bias).to have_and_belong_to_many(:groups_from).join_table('biases_from_groups').class_name('Group') }
        it { expect(bias).to have_and_belong_to_many(:groups_to).join_table('biases_to_groups').class_name('Group') }
        it { expect(bias).to have_and_belong_to_many(:cities_from).join_table('biases_from_cities').class_name('City') }
        it { expect(bias).to have_and_belong_to_many(:cities_to).join_table('biases_to_cities').class_name('City') }
        it { expect(bias).to have_and_belong_to_many(:departments_from).join_table('biases_from_departments').class_name('Department') }
        it { expect(bias).to have_and_belong_to_many(:departments_to).join_table('biases_to_departments').class_name('Department') }
    end

    context 'test validations' do
        it { expect(bias).to validate_presence_of(:description) }
    end
  end
end
