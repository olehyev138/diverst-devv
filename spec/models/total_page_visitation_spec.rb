require 'rails_helper'

RSpec.describe TotalPageVisitation, type: :model do
  it { should belong_to(:enterprise) }
end
