require 'rails_helper'

RSpec.describe Resource, :type => :model do

  describe 'test associations' do
    let(:resource) { build_stubbed(:resource) }

    it { expect(resource).to belong_to(:enterprise) }
    it { expect(resource).to belong_to(:folder) }
    it { expect(resource).to belong_to(:group) }
    it { expect(resource).to belong_to(:initiative) }
    it { expect(resource).to belong_to(:owner).class_name('User') }
    it { expect(resource).to have_many(:tags).dependent(:destroy) }
    it { expect(resource).to accept_nested_attributes_for(:tags) }
    it { expect(resource).to validate_length_of(:url)}
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
      create_list(:tag, 5, :resource => resource)

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
  
  describe "#destroy_callbacks" do
    it "removes the child objects" do
      resource = create(:resource)
      tag = create(:tag, :resource => resource)

      resource.destroy

      expect{Resource.find(resource.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{Tag.find(tag.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe '#total_views' do
    it "returns 10" do
        resource = create(:resource)
        create_list(:view, 10, :resource => resource)
        
        expect(resource.total_views).to eq(10)
    end
  end

  describe '.archive_expired_resources' do 
    let!(:group) { create(:group) }
    let!(:resources) { create_list(:resource, 3, group: group) }
    let!(:expired_resources) { create_list(:resource, 2, group: group, created_at: Time.now.weeks_ago(1), updated_at: Time.now.weeks_ago(1)) }

    it 'archives nothing if auto_archive is off' do 
      expect{ Resource.archive_expired_resources(group) }.to change(Resource.where.not(archived_at: nil), :count).by(0)
    end

    it 'archives expired resources when auto_archive is on' do 
      group.update(unit_of_expiry_age: 'weeks', expiry_age_for_news: 1, auto_archive: true)
      expect{ Resource.archive_expired_resources(group) }.to change(Resource.where.not(archived_at: nil), :count).by(2)
    end
  end
end
