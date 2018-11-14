require 'rails_helper'
require_relative '../../app/helpers/groups_helper.rb'

RSpec.describe "GroupsHelper" do
    let(:user) { create(:user) }
    let(:group) { create(:group, :enterprise_id => user.enterprise_id) }
    
    RSpec.configure do |c|
        c.include GroupsHelper
    end

    describe "#group_performance_label" do
        it "returns the correct label" do
            expect(group_performance_label(group)).to eq(link_to group.name, group)
        end
    end
end