require 'rails_helper'

RSpec.describe 'validate FactoryGirl factories' do
  FactoryGirl.factories.reject{ |f| f.name == :email }.each do |factory|
    context "with factory for :#{factory.name}" do
      it "is valid" do
        expect(build(factory.name)).to be_valid
      end
    end
  end
end
