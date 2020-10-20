require 'rails_helper'

RSpec.describe Update::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :field_data,
          :previous,
          :next,
          field_data: [
              :field,
              field: [:field_definer]
          ],
          previous: [
              :field_data,
              field_data: [
                  :field,
                  field: [:field_definer]
              ]
          ]
      ]
    }

    it { expect(Update.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end

  describe 'lesser_preloads' do
    let(:lesser_preloads) {
      [
          :field_data,
          field_data: [
              :field,
              field: [:field_definer]
          ]
      ]
    }

    it { expect(Update.lesser_preloads).to eq lesser_preloads }
  end
end
