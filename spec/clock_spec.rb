require "clockwork/test"
require 'rails_helper'

RSpec.describe Clockwork, :type => :clock do
  after(:each) { Clockwork::Test.clear! }
  
  before {Clockwork::Test.run(max_ticks: 1, start_time: DateTime.now.beginning_of_day, file: "./clock.rb")}
  
  it "runs the job Segment members" do
    job = "Update cached segment members"
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Segment.update_all_members 
  end
  
  it "runs the job SyncYammerUsersJob" do
    job = "Sync Yammer users with Diverst users"
    perform = SyncYammerUsersJob.perform_later
    
    allow(SyncYammerUsersJob).to receive(:perform_later).and_return(perform)
    
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq perform
  end
  
  it "runs the job SyncYammerGroupJob" do
    job = "Sync Yammer members"
    perform = SyncYammerGroupJob.perform_later
    
    allow(SyncYammerGroupJob).to receive(:perform_later).and_return(perform)
    
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.all.each { |group| SyncYammerGroupJob.perform_later(group) }
  end
  
  it "runs the job SaveUserDataSamplesJob" do
    job = "Save employee data samples"
    perform = SaveUserDataSamplesJob.perform_later
    
    allow(SaveUserDataSamplesJob).to receive(:perform_later).and_return(perform)
    
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq perform
  end
  
  it "runs the job UserGroupNotificationJob daily" do
    job = "Send daily notifications of groups to users"
    perform = UserGroupNotificationJob.perform_later
    
    allow(UserGroupNotificationJob).to receive(:perform_later).and_return(perform)
    
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq perform
  end
  
  it "runs the job GroupLeaderNotificationsJob" do
    job = "Send daily notifications of pending users to group leaders"
    perform = GroupLeaderNotificationsJob.perform_later
    
    allow(GroupLeaderNotificationsJob).to receive(:perform_later).and_return(perform)
    
    expect(Clockwork::Test.ran_job?(job)).to be_truthy
    expect(Clockwork::Test.times_run(job)).to eq 1
    expect(Clockwork::Test.block_for(job).call).to eq Group.where(:pending_users => "enabled").find_each { |group| GroupLeaderNotificationsJob.perform_later(group) }
  end
end