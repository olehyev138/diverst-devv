require 'rails_helper'

RSpec.describe 'validate FactoryBot factories' do
  FactoryBot.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      it 'is valid' do
        skip('looking into twitter error') if factory.name.to_s == 'twitter_account'
        expect(build(factory.name)).to be_valid
      end
    end
  end
end
