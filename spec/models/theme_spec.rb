require 'rails_helper'

RSpec.describe Theme, type: :model do
  it "doesnt validate with an invalid color" do
    expect(build(:theme, primary_color: "#zz1122")).to be_invalid
  end

  it "auto-appends a hash before the color if none is present" do
    theme = build(:theme, primary_color: "f15e58")
    theme.valid?
    expect(theme.primary_color).to eq '#f15e58'
  end

  it "doesnt auto-append a hash if one is already present" do
    theme = build(:theme, primary_color: "#f15e58")
    is_valid = theme.valid?
    expect(theme.primary_color).to eq '#f15e58'
  end

  it "validates with a valid color" do
    expect(build(:theme, primary_color: "#f15e58")).to be_valid
  end
end
