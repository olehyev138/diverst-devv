require 'rails_helper'

RSpec.describe Reward do
  describe "when validating" do
    let(:reward){ build_stubbed(:reward) }

    it{ expect(reward).to validate_presence_of(:enterprise) }
    it{ expect(reward).to validate_numericality_of(:points).only_integer }
    it{ expect(reward).to validate_presence_of(:points) }
    it{ expect(reward).to validate_presence_of(:label) }
    it{ expect(reward).to validate_presence_of(:responsible) }
    it{ expect(reward).to have_attached_file(:picture) }
    it {
      expect(reward).to validate_attachment_content_type(:picture).
        allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml')
    }
    it{ expect(reward).to belong_to(:enterprise) }
    it { expect(reward).to belong_to(:responsible).class_name("User").with_foreign_key("responsible_id") }
  end
end
