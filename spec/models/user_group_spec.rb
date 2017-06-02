require 'rails_helper'

RSpec.describe UserGroup do
  describe "when validating" do
    let(:user_group){ build_stubbed(:user_group) }

    it { expect(user_group).to define_enum_for(:frequency_notification).with([:real_time, :daily, :weekly, :disabled]) }
  end
end
