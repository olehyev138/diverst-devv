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

  describe 'archive expired resources after_commit on [:create, :update, :destroy]' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:folder) { create(:folder, enterprise: enterprise) }
    let!(:expired_resource) { create(:resource, title: "resource 1", folder: folder, created_at: DateTime.now.months_ago(9),
     updated_at: DateTime.now.months_ago(9),
    group: group) }
    let!(:new_resource) { create(:resource, title: "resource 2", folder: folder, group: group) }

    it 'on update' do
      new_resource.run_callbacks :update
      expect(expired_resource.reload.archived_at).to_not be_nil
    end

    it 'on destroy' do
      new_resource.run_callbacks :destroy
      expect(expired_resource.reload.archived_at).to_not be_nil
    end

    it 'on create' do
      fresh_resource = build(:resource, folder: folder, group: group)
      fresh_resource.run_callbacks :create
      expect(expired_resource.reload.archived_at).to_not be_nil
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

  describe 'elasticsearch methods' do
    context '#as_indexed_json' do
      let!(:object) { create(:resource) }

      it 'serializes the correct fields with the correct data' do
        hash = {
          'created_at' => object.created_at.beginning_of_hour,
          'owner_id' => object.owner_id,
          'folder' => {
            'id' => object.folder_id,
            'group_id' => object.folder.group_id,
            'group' => {
              'enterprise_id' => object.folder.group.enterprise_id
            }
          }
        }
        expect(object.as_indexed_json).to eq(hash)
      end
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
end
