RSpec.shared_examples "correct public activity" do
  it 'creates public activity with correct params' do
    activity = PublicActivity::Activity.last

    expect(activity.trackable_id).to eq model.id
    expect(activity.trackable_type).to eq model.class.to_s

    expect(activity.owner_id).to eq owner.id
    expect(activity.owner_type).to eq owner.class.to_s

    expect(activity.recipient).to eq owner.enterprise
  end
end