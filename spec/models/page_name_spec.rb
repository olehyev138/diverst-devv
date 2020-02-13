require 'rails_helper'

RSpec.describe PageName, type: :model do
  let(:page_name) { build_stubbed(:page_name) }

  it { expect(page_name).to have_many(:visits).class_name('PageVisitationData').with_foreign_key('page_url') }
end
