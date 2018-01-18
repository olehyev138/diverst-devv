require 'rails_helper'

RSpec.describe GroupLeaderDecorator do
    
    describe "#enabled_status" do
        context "when notifications_enabled" do
            it "returns off" do
                group_leader = create(:group_leader)
                decorated_group_leader = group_leader.decorate
                expect(decorated_group_leader.enabled_status(group_leader.notifications_enabled)).to eq("Off")
            end
            
            it "returns on" do
                group_leader = create(:group_leader, :notifications_enabled => true)
                decorated_group_leader = group_leader.decorate
                expect(decorated_group_leader.enabled_status(group_leader.notifications_enabled)).to eq("On")
            end
        end
    end
end