require 'rails_helper'

RSpec.describe City, type: :model do
  let(:city) { build :city }

  describe 'factory' do
    it 'is valid' do
      expect(city).to be_valid
    end
  end

  describe 'validation' do
    describe 'name' do
      it 'is present' do
        city.name = nil
        expect(city).to be_invalid
      end

      it 'is not empty' do
        city.name = ''
        expect(city).to be_invalid
      end
    end
  end
end
