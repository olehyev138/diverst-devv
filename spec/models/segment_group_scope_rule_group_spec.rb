require 'rails_helper'

RSpec.describe SegmentGroupScopeRuleGroup, type: :model do
  it { should belong_to(:segment_group_scope_rule) }
  it { should belong_to(:group) }
end
