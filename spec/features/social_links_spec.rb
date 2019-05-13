require 'rails_helper'
# Derek
# Here I want you to test how our social-media posting feature works
# In order to see social media posting button, add
# ENABLE_SOCIAL_MEDIA: 'true'
# to your appication.yml
# and you'll be able to see social media creation button at user news page

# We currently support Youtube, Facebook, Twitter and Instagram
# For each of those, you need to create separate scenario
# In scenario, you go to new social media page, post link to social media
# Then you go to group news page end expect to find embeddable html for particular item
RSpec.feature 'Social Links' do
  let(:user) { create(:user) }
  let(:group) { create(:group, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'posting Youtube' do
  end

  scenario 'posting Twitter' do
  end

  scenario 'posting Facebook' do
  end

  scenario 'posting Instagram' do
  end
end
