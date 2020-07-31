require 'rails_helper'

RSpec.describe Sponsor::Actions, type: :model do
  describe 'valid_scopes' do
    let(:valid_scopes) { %w(
                                    group_sponsor
                                    enterprise_sponsor
                                )
    }

    it { expect(Sponsor.valid_scopes).to eq valid_scopes }
  end

  describe 'base_attributes_preloads' do
    let(:base_attributes_preloads) { [:sponsor_media_attachment] }

    it { expect(Sponsor.base_attributes_preloads).to eq base_attributes_preloads }
  end
end
