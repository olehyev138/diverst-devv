require 'rails_helper'

RSpec.describe Theme, type: :model do
  describe 'color validation' do
    it 'is invalid with incorrect color' do
      expect(build(:theme, primary_color: '#zz1122')).to be_invalid
    end

    it 'is valid with correct color' do
      expect(build(:theme, primary_color: '#f15e58')).to be_valid
    end
  end

  describe 'appending hash to colors' do
    it 'triggers if hash is not present' do
      theme = build(:theme, primary_color: 'f15e58')
      theme.valid?
      expect(theme.primary_color).to eq '#f15e58'
    end

    it 'does not trigger if hash is present' do
      theme = build(:theme, primary_color: '#f15e58')
      theme.valid?
      expect(theme.primary_color).to eq '#f15e58'
    end
  end
end
