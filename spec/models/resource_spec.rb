require 'rails_helper'

RSpec.describe Resource, :type => :model do

  describe 'test associations' do
    let(:resource) { build_stubbed(:resource) }

    it { expect(resource).to belong_to(:container) }
    it { expect(resource).to belong_to(:owner).class_name('User') }
    it { expect(resource).to have_many(:tags).dependent(:destroy) }
    it { expect(resource).to accept_nested_attributes_for(:tags) }
  end

  describe 'when validating' do
    let(:resource){ build_stubbed(:resource) }

    it{ expect(resource).to validate_presence_of(:title)}
    it{ expect(resource).to have_attached_file(:file)}

    #do we want to validate presence of file in resource model? if so then i will uncomment this code
    # it{ expect(resource).to validate_attachment_presence(:file)}
  end

  describe 'test callbacks' do
      let(:resource) { build_stubbed(:resource) }

    context 'before_validation' do
      it '#smart_add_url_protocol is called before validation' do
        expect(resource).to receive(:smart_add_url_protocol)
        resource.valid?
      end
    end
  end

  describe '#extension' do
    it "returns the file's lowercase extension without the dot" do
      resource = build_stubbed(:resource)
      expect(resource.file_extension).to eq 'csv'
    end
  end

  describe '#tag_tokens' do
    it "doesnt create tags" do
      resource = create(:resource)
      resource.tag_tokens = nil

      resource.reload
      expect(resource.tags.count).to eq(0)
    end

    it "doesnt create tags" do
      resource = create(:resource)
      resource.tag_tokens = []

      resource.reload
      expect(resource.tags.count).to eq(0)
    end

    it "doesnt create tags" do
      resource = create(:resource)
      resource.tag_tokens = ""

      resource.reload
      expect(resource.tags.count).to eq(0)
    end

    it "create tags" do
      resource = create(:resource)
      resource.tag_tokens = ["tag_1", "tag_2", "tag_3", "tag_4"]

      resource.reload
      expect(resource.tags.count).to eq(4)
    end

    it "saves and create tags" do
      resource = create(:resource)
      tag = resource.tags.new(:name => "tag_5")
      tag.save!

      resource.tag_tokens = [tag.id, "tag_1", "tag_2", "tag_3", "tag_4"]

      resource.reload
      expect(resource.tags.count).to eq(5)
    end

    it "deletes tags" do
      resource = create(:resource)
      create_list(:tag, 5, :taggable => resource)

      resource.tag_tokens = []

      resource.reload
      expect(resource.tags.count).to eq(0)
    end
  end

  describe "#file_extension" do
    it "returns '' " do
      resource = build(:resource, :file_file_name => nil, :file => nil)
      expect(resource.file_extension).to eq("")
    end
  end

  describe "#expiration_time" do
    it "returns the expiration_time " do
      resource = create(:resource)
      expect(resource.expiration_time).to eq(Resource::EXPIRATION_TIME)
    end
  end
end
