require 'rails_helper'

RSpec.describe ImportCSVJob, type: :job do
  let!(:csv_file) { create(:csv_file) }

  it 'imports the file and sends an email' do
    subject.perform(csv_file.id)

    expect(csv_file.user.enterprise.users.count).to eq(3)
  end
end
