require 'rails_helper'

RSpec.describe GroupDecorator do

    let(:user) {create(:user)}
    let(:group){ create(:group, enterprise: user.enterprise) }
    let!(:budget){ create(:budget, subject: group, is_approved: true) }

    describe "#spendings_percentage" do
        it "returns 0" do
            decorated_group = group.decorate
            expect(decorated_group.spendings_percentage).to eq(0)
        end
        
        it "returns 100" do
            group.annual_budget = 0
            group.save
            
            decorated_group = group.decorate
            expect(decorated_group.spendings_percentage).to eq(100)
        end
        
        it "returns 25.0" do
            budget.budget_items.each do |item|
                item.estimated_amount = 10
                item.save
            end
            group.annual_budget = 120
            group.save
            
            decorated_group = group.decorate
            expect(decorated_group.spendings_percentage).to eq(25.0)
        end
    end
end