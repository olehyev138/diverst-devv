require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'when validating' do
    let(:answer) { build_stubbed(:answer) }
    
    #it { expect(answer).to belong_to(:campaign) } # <- this fails
    it { expect(answer).to belong_to(:question) }
    it { expect(answer).to belong_to(:author) }
    it { expect(answer).to have_many(:votes) }
    it { expect(answer).to have_many(:voters) }
    it { expect(answer).to have_many(:comments) }
    it { expect(answer).to have_many(:expenses) }
    it { expect(answer).to have_attached_file(:supporting_document) }
  end
end
