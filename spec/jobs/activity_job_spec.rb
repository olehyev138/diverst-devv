require 'rails_helper'

RSpec.describe ActivityJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'creates the activity' do
      PublicActivity.with_tracking do
        user = create(:user)
        news_link = create(:news_link)

        subject.perform(news_link.class.name, news_link.id, 'create', user.id)

        expect(PublicActivity::Activity.all.count).to eq(1)
      end
    end
  end
end
