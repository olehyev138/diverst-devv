require 'rails_helper'

RSpec.describe FolderShare, type: :model do
    
    describe "when validating" do
        let(:folder_share){ create(:folder_share) }
        
        it{ expect(folder_share).to belong_to(:folder) }
        it{ expect(folder_share).to belong_to(:container) }
        
        it { expect(folder_share).to validate_presence_of(:folder) }
        it { expect(folder_share).to validate_presence_of(:container) }
    end
end
