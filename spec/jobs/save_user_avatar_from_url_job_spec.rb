require 'rails_helper'

RSpec.describe SaveUserAvatarFromUrlJob, type: :job do
  include ActiveJob::TestHelper
  let!(:user) { create(:user) }

  it 'saves the url' do
    subject.perform(user.id, Faker::Avatar.image)

    user.reload

    expect(user.avatar).to_not be(nil)
  end

  it 'is rescued when url is bad' do
    subject.perform(user.id, 'superbadurl')

    user.reload

    expect(user.avatar).to_not be(nil)
  end
end
