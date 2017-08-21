require 'rails_helper'
require "#{ Rails.root }/spec/concerns/optionnable_spec"

RSpec.describe GroupField, type: :model do
  it_behaves_like "optionnable"
end
