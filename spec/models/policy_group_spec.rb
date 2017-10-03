require 'rails_helper'

RSpec.describe PolicyGroup, type: :model do
    
    describe 'validations' do
        let(:policy_group) { FactoryGirl.build_stubbed(:policy_group) }

        it{ expect(policy_group).to validate_presence_of(:name) }
        it{ expect(policy_group).to validate_presence_of(:enterprise) }
    end
    
    describe '.default_group' do
        context 'within single enterprise' do
            let!(:enterprise) { FactoryGirl.create(:enterprise) }
            let!(:not_default_pg) { FactoryGirl.create(:policy_group, enterprise: enterprise) }
            let!(:default_group) { FactoryGirl.create(:policy_group, enterprise: enterprise, default_for_enterprise: true) }

            it 'returns default group' do
                expect(
                    described_class.default_group(enterprise.id)
                ).to eq default_group
            end
        end

        describe 'different enterprises' do
            let!(:enterprise1) { FactoryGirl.create(:enterprise) }
            let!(:enterprise2) { FactoryGirl.create(:enterprise) }
            let!(:e1_policy_group) { FactoryGirl.create(:policy_group, enterprise: enterprise1, default_for_enterprise: true) }
            let!(:e2_policy_group) { FactoryGirl.create(:policy_group, enterprise: enterprise2, default_for_enterprise: true) }

            it 'do not share default groups' do
                expect(
                    described_class.default_group(enterprise1.id)
                ).to eq e1_policy_group

                expect(
                    described_class.default_group(enterprise2.id)
                ).to eq e2_policy_group
            end
        end
    end

    describe 'default group behaviour' do
        let!(:enterprise) { FactoryGirl.create(:enterprise) }

        describe 'new group creation' do
            describe 'when creating not default group' do
                let!(:new_group) {
                    FactoryGirl.build(:policy_group, enterprise: enterprise)
                }

                context 'with existing default group' do
                    let!(:existing_group) {
                        FactoryGirl.create(:policy_group,
                                           enterprise: enterprise,
                                           default_for_enterprise: true)
                    }

                    it 'does not change existing default group' do
                        new_group.save

                        expect(enterprise.default_policy_group).to eq existing_group
                    end
                end

                context 'without existing default group' do
                    it 'sets new group to default' do
                        new_group.save

                        expect(enterprise.default_policy_group).to eq new_group
                    end
                end
            end

            describe 'when creating default group' do
                let!(:new_group) {
                    FactoryGirl.build(:policy_group,
                                      enterprise: enterprise,
                                      default_for_enterprise: true)
                }

                context 'with existing default group' do
                    let!(:existing_group) {
                        FactoryGirl.create(:policy_group,
                                           enterprise: enterprise,
                                           default_for_enterprise: true)
                    }

                    before { new_group.save }

                    it 'sets new group to default' do
                        expect(enterprise.default_policy_group).to eq new_group
                    end

                    it 'marks all other groups as not default' do
                        expect(existing_group.reload.default_for_enterprise).to eq false
                    end
                end

                context 'without existing default group' do
                    before { new_group.save }

                    it 'sets new group to default' do
                        expect(enterprise.default_policy_group).to eq new_group
                    end
                end
            end
        end

        describe 'default group deletion' do
            let!(:default_pg) {
                FactoryGirl.create(:policy_group,
                                   enterprise: enterprise,
                                   default_for_enterprise: true)
            }

            let!(:not_default_pg) {
                FactoryGirl.create(:policy_group,
                                   enterprise: enterprise)
            }

            before { default_pg.destroy }

            it 'sets first of existing groups to default' do
                expect(not_default_pg.reload).to be_default_group
            end
        end
    end
end
