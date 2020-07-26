require 'rails_helper'

RSpec.describe Mentoring::Actions, type: :model do
  describe 'valid_includes' do
    it { expect(Mentoring.valid_includes.include?('mentee')).to eq true }
    it { expect(Mentoring.valid_includes.include?('mentor')).to eq true }
  end
end
