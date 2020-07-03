require 'rails_helper'

RSpec.describe View, type: :model do
  let(:view) { create :view }

  describe 'factory' do
    it 'is valid' do
      expect(view).to be_valid
    end
  end

  describe 'associations' do
    it { expect(view).to belong_to(:news_feed_link).counter_cache(true) }
    it { expect(view).to belong_to(:group).counter_cache(true) }
    it { expect(view).to belong_to(:user) }
    it { expect(view).to belong_to(:enterprise) }
    it { expect(view).to belong_to(:resource).counter_cache(true) }
    it { expect(view).to belong_to(:folder).counter_cache(true) }
  end

  describe 'elasticsearch methods' do
    context '#as_indexed_json' do
      let!(:object) { create(:view) }

      # TODO: Handle different view container types (group, folder, resource, etc.)
      it 'serializes the correct fields with the correct data' do
        hash = {
          'enterprise_id' => object.enterprise_id,
          'group_id' => object.group_id,
          'created_at' => object.created_at.beginning_of_hour,
          'news_feed_link' => {
            'news_link' => {
              'id' => object.news_feed_link.news_link.id,
              'title' => object.news_feed_link.news_link.title,
            },
            'group' => {
              'id' => object.news_feed_link.group.id,
              'name' => object.news_feed_link.group.name
            }
          }
        }
        expect(object.as_indexed_json).to eq(hash)
      end
    end
  end
end
