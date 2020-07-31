require 'rails_helper'

RSpec.describe Poll::Actions, type: :model do
  describe 'base_preloads' do
    let!(:base_preloads) { [:fields, :groups, :segments, :enterprise] }
    it { expect(Poll.base_preloads).to eq base_preloads }
  end
end
