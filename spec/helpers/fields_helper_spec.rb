require 'rails_helper'

RSpec.describe FieldsHelper do
  let!(:field) { create(:field) }

  describe '#required_class' do
    it 'returns hidden if field is not required' do
      expect(required_class(field)).to eq 'hidden'
    end

    it 'returns a empty string if field is required' do
      field.update(required: true)
      expect(required_class(field)).to eq ''
    end
  end

  describe '#field_error_class' do
    let!(:resource) { create(:resource) }
    let!(:checkbox_field) { create(:checkbox_field) }

    it 'returns a blank string when ' do
      expect(field_error_class(resource, checkbox_field)).to eq ''
    end
  end
end
