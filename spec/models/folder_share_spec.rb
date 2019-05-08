require 'rails_helper'

RSpec.describe FolderShare, type: :model do
  describe 'when validating' do
    let(:folder_share) { build_stubbed(:folder_share) }

    it { expect(folder_share).to belong_to(:folder) }
    it { expect(folder_share).to belong_to(:enterprise) }
    it { expect(folder_share).to belong_to(:group) }

    it { expect(folder_share).to validate_presence_of(:folder) }
  end
end
