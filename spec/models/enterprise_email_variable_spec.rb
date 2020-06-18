require 'rails_helper'

RSpec.describe EnterpriseEmailVariable do
  it { should belong_to(:enterprise) }

  it { should have_many(:email_variables) }
  it { should have_many(:emails).through(:email_variables) }

  it { should validate_length_of(:example).is_at_most(65535) }
  it { should validate_length_of(:description).is_at_most(191) }
  it { should validate_length_of(:key).is_at_most(191) }
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:description) }
end

