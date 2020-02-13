require 'rails_helper'

RSpec.describe PageVisitationData, type: :model do
  let(:page_visitation_data) { build(:page_visitation_data) }

  it { expect(page_visitation_data).to validate_length_of(:action).is_at_most(191) }
  it { expect(page_visitation_data).to validate_length_of(:controller).is_at_most(191) }
  it { expect(page_visitation_data).to validate_length_of(:page_url).is_at_most(191) }

  it { expect(page_visitation_data).to validate_uniqueness_of(:page_url).scoped_to(:user_id) }

  it { expect(page_visitation_data).to belong_to(:user) }
  it { expect(page_visitation_data).to belong_to(:page_name).class_name('PageName').with_foreign_key(:page_url) }

  describe '#name' do
    let(:page_visitation_data) { build(:page_visitation_data, page_name: create(:page_name, page_name: 'new page')) }
    it { expect(page_visitation_data.name).to eq 'new page' }
  end

  describe '.end_of_day_count' do
    let!(:page_visitation_data1) { create(:page_visitation_data, visits_day: 1, visits_week: 2, visits_month: 3, visits_year: 2,
                                                                 created_at: 1.5.weeks.ago, updated_at: 1.week.ago)
    }

    it 'returns end of day count' do
      expect { described_class.end_of_day_count }.to change { page_visitation_data1.reload.visits_week }.from(2).to(1)
    end
  end
end
