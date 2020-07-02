require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:like) { build(:like) }

  it { expect(like).to belong_to(:enterprise) }
  it { expect(like).to belong_to(:user) }
  it { expect(like).to belong_to(:news_feed_link).counter_cache(true) }
  it { expect(like).to belong_to(:answer).counter_cache(true) }

  it { expect(like).to validate_presence_of(:enterprise_id) }
  it { expect(like).to validate_presence_of(:user_id) }
end
