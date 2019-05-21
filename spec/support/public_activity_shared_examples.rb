RSpec.shared_examples 'correct public activity' do
  it 'creates public activity with correct params' do
    activity = PublicActivity::Activity.last

    expect(activity.key).to eq key

    if key.include? 'destroy' # for deletion, there is no trackable anymore
      expect(activity.trackable).to be_nil
    else
      expect(activity.trackable_id).to eq model.id
      expect(activity.trackable_type).to eq model.class.to_s
    end

    expect(activity.owner_id).to eq owner.id
    expect(activity.owner_type).to eq owner.class.to_s

    expect(activity.recipient).to eq owner.enterprise
  end
end
