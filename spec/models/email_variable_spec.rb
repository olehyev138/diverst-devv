require 'rails_helper'

RSpec.describe EmailVariable do
  it { expect(subject).to respond_to(:enterprise_email_variable) }
  it { expect(subject).to respond_to(:email) }
end
