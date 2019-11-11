require 'rails_helper'

RSpec.describe PageVisitation, type: :model do
  it { should belong_to(:user) }
end
