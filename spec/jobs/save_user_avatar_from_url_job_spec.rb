require 'rails_helper'

RSpec.describe SaveUserAvatarFromUrlJob, type: :job do
  include ActiveJob::TestHelper
  let!(:user){ create(:user) }
  
  it "saves the url", skip: "skipped because of inconsistent results" do
    subject.perform(user, Faker::Avatar.image)
    
    user.reload
    
    expect(user.avatar).to_not be(nil)
  end
end
