require 'rails_helper'

RSpec.describe Folder, type: :model do
    
    describe "when validating" do
        let(:group) { create(:group) }
        let(:folder){ create(:folder, :name => "test", :container => group) }

        it { expect(folder).to have_many(:resources) }
        it { expect(folder).to have_many(:folder_shares) }
        it { expect(folder).to have_many(:groups) }
        
        it{ expect(folder).to belong_to(:container) }
        
        it { expect(folder).to validate_presence_of(:name) }
        it { expect(folder).to validate_presence_of(:container) }
        #it { expect(folder).to validate_uniqueness_of(:name) } # <- revisit
    end
end
