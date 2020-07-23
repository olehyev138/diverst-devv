require 'rails_helper'

RSpec.describe Email::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Email.base_preloads.include?(:email_variables)).to eq true }
    it { expect(Email.base_preloads.include?(:variables)).to eq true }
  end
end
