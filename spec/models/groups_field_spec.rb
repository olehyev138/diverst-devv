require 'rails_helper'
require "#{ Rails.root }/spec/concerns/optionnable_spec"

RSpec.describe GroupsField, type: :model do
  it_behaves_like "optionnable"
end
