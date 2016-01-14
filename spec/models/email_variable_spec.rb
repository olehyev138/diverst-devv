require 'rails_helper'

<<<<<<< HEAD
RSpec.describe EmailVariable do
=======
RSpec.describe EmailVariable, type: :model do
>>>>>>> 419856bf8a245c116c0d27bb483da12dfc794b5e
  it { expect(subject).to respond_to(:key) }
  it { expect(subject).to respond_to(:description) }
  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:required) }
end
