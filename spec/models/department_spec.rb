require 'rails_helper'

RSpec.describe Department, type: :model do
let(:department) { build_stubbed :department }

  describe 'factory' do
    it 'is valid' do
      expect(department).to be_valid
    end
  end

  describe 'validation' do
    it 'is invalid without enterprise' do
      department.enterprise_id = nil
      expect(department).to be_invalid
    end

    describe 'name' do
      it 'is present' do
        department.name = nil
        expect(department).to be_invalid
      end

      it 'is not empty' do
        department.name = ''
        expect(department).to be_invalid
      end
    end
  end
end
