require 'rails_helper'

RSpec.describe EmailVariable do
  it { expect(subject).to respond_to(:key) }
  it { expect(subject).to respond_to(:description) }
  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:required) }
end
