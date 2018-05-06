require 'rails_helper'

RSpec.describe Enterprise, type: :model do
    
    describe "when validating" do
        let(:enterprise){ create(:enterprise) }

        it { expect(enterprise).to have_many(:rewards) }
        it { expect(enterprise).to have_many(:reward_actions) }
        it { expect(enterprise).to have_many(:badges) }
        it { expect(enterprise).to have_many(:folders) }
        it { expect(enterprise).to have_many(:folder_shares) }
        it { expect(enterprise).to have_many(:shared_folders) }
        it { expect(enterprise).to have_many(:group_categories) }
        it { expect(enterprise).to have_many(:group_category_types) }
        
        it{ expect(enterprise).to have_one(:custom_text) }
    end
    
    describe "#company_video_url" do
        it "saves the url" do
            enterprise = create(:enterprise, :company_video_url => "https://www.youtube.com/watch?v=Y2VF8tmLFHw")
            expect(enterprise.company_video_url).to_not be(nil)
        end
    end
    
    describe "#update_matches" do
        it "calls GenerateEnterpriseMatchesJob" do
            enterprise = create(:enterprise)
            allow(GenerateEnterpriseMatchesJob).to receive(:perform_later)
            
            enterprise.update_matches
            expect(GenerateEnterpriseMatchesJob).to have_received(:perform_later)
        end
    end
    
    describe "#update_match_scores" do
        it "calls CalculateMatchScoreJob" do
            enterprise = create(:enterprise)
            create_list(:user, 2, :enterprise => enterprise)
            allow(CalculateMatchScoreJob).to receive(:perform_later)
            
            enterprise.update_match_scores
            expect(CalculateMatchScoreJob).to have_received(:perform_later).at_least(:once)
        end
    end

    describe "#custom_text" do
        context "when enterprise does not have a custom_text" do
            let!(:enterprise){ create(:enterprise, custom_text: nil) }

            it "create a new custom_text" do
                expect(enterprise.custom_text).to be_an_instance_of(CustomText)
            end
        end

        context "when enterprise have a custom_text" do
            let!(:custom_text){ create(:custom_text) }
            let!(:enterprise){ create(:enterprise, custom_text: custom_text) }

            it "return the custom_text" do
                expect(enterprise.custom_text).to eq custom_text
            end
        end
    end
    
    describe "#default_time_zone" do

        it "returns UTC" do
            enterprise = create(:enterprise, time_zone: nil)
            expect(enterprise.default_time_zone).to eq "UTC"
        end
        
        it "returns EST" do
            enterprise = create(:enterprise, time_zone: "EST")
            expect(enterprise.default_time_zone).to eq "EST"
        end
    end

    describe ".cdo_message_email_html" do
        context "when cdo_message_email is not nil" do
            let(:enterprise){ build_stubbed(:enterprise, cdo_message_email: "test \r\n test") }

            it "change \r\n to br tag" do
                pending 'TODO: Move this check to Decorator, use decorator in views'
                expect(enterprise.cdo_message_email_html).to eq "test <br> test"
            end
        end
    end

    describe '#sso_fields_to_enterprise_fields' do
        let!(:enterprise) { create :enterprise }
        let!(:age_field) { create :field, saml_attribute: 'age' }
        let!(:gender_field) { create :field, saml_attribute: 'gender' }

        let(:saml_fields) {
            {
                'age' => 23,
                'gender' => 'male',
                'department' => 'IT'
            }
        }

        before do
            enterprise.fields << age_field
            enterprise.fields << gender_field
        end

        it 'maps sso fields to existing fields' do
            mapped_fields = enterprise.sso_fields_to_enterprise_fields(saml_fields)

            expect(mapped_fields.length).to eq 2
            expect(mapped_fields).to include(age_field.id => saml_fields['age'])
            expect(mapped_fields).to include(gender_field.id => saml_fields['gender'])

            expect(mapped_fields).to_not have_key 'department'
        end
    end
    
    describe "#destroy_callbacks" do
        it "removes the child objects" do
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)
            field = create(:field, :enterprise => enterprise)
            topic = create(:topic, :enterprise => enterprise)
            segment = create(:segment, :enterprise => enterprise)
            group = create(:group, :enterprise => enterprise)
            folder = create(:folder, :enterprise => enterprise)
            folder_share = create(:folder_share, :enterprise => enterprise)
            poll = create(:poll, :enterprise => enterprise)
            mobile_field = create(:mobile_field, :enterprise => enterprise)
            metrics_dashboard = create(:metrics_dashboard, :enterprise => enterprise)
            campaign = create(:campaign, :enterprise => enterprise)
            resource = create(:resource, :enterprise => enterprise)
            yammer_field_mapping = create(:yammer_field_mapping, :enterprise => enterprise)
            email = create(:email, :enterprise => enterprise)
            expense = create(:expense, :enterprise => enterprise)
            expense_category = create(:expense_category, :enterprise => enterprise)
            default_user_role = enterprise.user_roles.where(:default => true).first
            policy_group_template = default_user_role.policy_group_template
            reward = create(:reward, :enterprise => enterprise, :responsible => user)
            reward_action = create(:reward_action, :enterprise => enterprise)
            badge = create(:badge, :enterprise => enterprise)
            group_category = create(:group_category, :enterprise => enterprise)
            group_category_type = create(:group_category_type, :enterprise => enterprise)
            
            enterprise.destroy!
            
            expect{Enterprise.find(enterprise.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Field.find(field.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Topic.find(topic.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Segment.find(segment.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Group.find(group.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Folder.find(folder.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{FolderShare.find(folder_share.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Poll.find(poll.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{MobileField.find(mobile_field.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{MetricsDashboard.find(metrics_dashboard.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Campaign.find(campaign.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{YammerFieldMapping.find(yammer_field_mapping.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Email.find(email.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Expense.find(expense.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{ExpenseCategory.find(expense_category.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{UserRole.find(default_user_role.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{PolicyGroupTemplate.find(policy_group_template.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Reward.find(reward.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{RewardAction.find(reward_action.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Badge.find(badge.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{GroupCategory.find(group_category.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{GroupCategoryType.find(group_category_type.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end
