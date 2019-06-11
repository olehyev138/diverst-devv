require 'rails_helper'

RSpec.describe InvalidInputException, type: :exception do
  describe '#initialize' do
    it 'sets the exception attribute and message' do
      exception = InvalidInputException.new('password', 'Incorrect password')
      expect(exception.message).to eq('Incorrect password')
      expect(exception.attribute).to eq('password')
    end
  end
end
