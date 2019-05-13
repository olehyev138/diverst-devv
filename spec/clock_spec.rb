require 'clockwork/test'
require 'rails_helper'

RSpec.describe Clockwork, type: :clock do
  after(:each) { Clockwork::Test.clear! }

  before { Clockwork::Test.run(max_ticks: 1, start_time: DateTime.now.beginning_of_day, file: './clock.rb') }

  it 'runs the job Segment members' do
    job = 'Update cached segment members'
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Segment.update_all_members
  end

  xit 'runs the job SyncYammerUsersJob' do
    job = 'Sync Yammer users with Diverst users'
    perform = SyncYammerUsersJob.perform_later

    allow(SyncYammerUsersJob).to receive(:perform_later).and_return(perform)

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq perform
  end

  xit 'runs the job SyncYammerGroupJob' do
    job = 'Sync Yammer members'
    perform = SyncYammerGroupJob.perform_later

    allow(SyncYammerGroupJob).to receive(:perform_later).and_return(perform)

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.all.each { |group| SyncYammerGroupJob.perform_later(group.id) }
  end

  it 'runs the job GroupLeaderMemberNotificationsJob' do
    job = 'Send daily notifications of pending users to group leaders'
    perform = GroupLeaderMemberNotificationsJob.perform_later

    allow(GroupLeaderMemberNotificationsJob).to receive(:perform_later).and_return(perform)

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.where(pending_users: 'enabled').find_each { |group| GroupLeaderMemberNotificationsJob.perform_later(group.id) }
  end

  it 'runs the job GroupLeaderCommentNotificationsJob' do
    job = 'Send daily notifications of pending comments to group leaders'
    perform = GroupLeaderCommentNotificationsJob.perform_later

    allow(GroupLeaderCommentNotificationsJob).to receive(:perform_later).and_return(perform)

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.find_each { |group| GroupLeaderCommentNotificationsJob.perform_later(group.id) }
  end

  it 'runs the job GroupLeaderPostNotificationsJob' do
    job = 'Send daily notifications of pending posts to group leaders'
    perform = GroupLeaderPostNotificationsJob.perform_later

    allow(GroupLeaderPostNotificationsJob).to receive(:perform_later).and_return(perform)

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.find_each { |group| GroupLeaderPostNotificationsJob.perform_later(group.id) }
  end

  it 'archive expired news' do
    job = 'Archive expired news'

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.find_each { |group| NewsFeedLink.archive_expired_news(group) }
  end

  it 'archive expired resources' do
    job = 'Archive expired resources'

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.find_each { |group| Resource.archive_expired_resources(group) }
  end

  it 'archive expired events' do
    job = 'Archive expired events'

    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.find_each { |group| Initiative.archive_expired_events(group) }
  end
end
