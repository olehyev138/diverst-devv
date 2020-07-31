require 'rails_helper'

RSpec.describe Email::Actions, type: :model do
  describe 'base_preloads' do
    let!(:base_preloads) { [:email_variables, :variables] }
    it { expect(Email.base_preloads).to eq base_preloads }
  end
end
