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

        it "returns 100"  do
            outcome = create(:outcome, :group => group)
            pillar = create(:pillar, :outcome => outcome)
            initiative = create(:initiative, :pillar => pillar)
            create(:initiative_expense, :initiative => initiative, :amount => 100)
                
            group.annual_budget = 100
            group.save

            decorated_group = group.decorate
            expect(decorated_group.spendings_percentage).to eq(100)
        end

        it "returns 80.0"do
            (1..4).each do
                outcome = create(:outcome, :group => group)
                pillar = create(:pillar, :outcome => outcome)
                initiative = create(:initiative, :pillar => pillar)
                create_list(:initiative_expense, 2, :initiative => initiative, :amount => 10)
            end
            
            budget.budget_items.each do |item|
                item.estimated_amount = 40
                item.save
            end
            group.annual_budget = 100
            group.save

            decorated_group = group.decorate
            expect(decorated_group.spendings_percentage).to eq(80.0)
        end
    end
end