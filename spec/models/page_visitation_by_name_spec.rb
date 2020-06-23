require 'rails_helper'

RSpec.describe PageVisitationByName, type: :model do
  it { should belong_to(:user) }
end
