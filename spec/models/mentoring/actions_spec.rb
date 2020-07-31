require 'rails_helper'

RSpec.describe Mentoring::Actions, type: :model do
  describe 'valid_includes' do
    let!(:valid_includes) { %w(mentee mentor) }
    it { expect(Mentoring.valid_includes).to eq valid_includes }
  end
end
