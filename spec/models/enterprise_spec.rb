require 'rails_helper'

RSpec.describe Enterprise, type: :model do

    describe "when validating" do
        let(:enterprise){ create(:enterprise) }

        it { expect(enterprise).to have_many(:users).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:graph_fields).class_name('Field') }
        it { expect(enterprise).to have_many(:fields) }
        it { expect(enterprise).to have_many(:topics).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:segments).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:groups).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:events).through(:groups) }
        it { expect(enterprise).to have_many(:initiatives).through(:groups) }
        it { expect(enterprise).to have_many(:folders) }
        it { expect(enterprise).to have_many(:folder_shares) }
        it { expect(enterprise).to have_many(:shared_folders).through(:folder_shares).source('folder') }
        it { expect(enterprise).to have_many(:polls).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:mobile_fields).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:metrics_dashboards).inverse_of(:enterprise) }
        it { expect(enterprise).to have_many(:graphs).through(:metrics_dashboards) }
        it { expect(enterprise).to have_many(:poll_graphs).through(:polls).source(:graphs) }
        it { expect(enterprise).to have_many(:campaigns) }
        it { expect(enterprise).to have_many(:questions).through(:campaigns) }
        it { expect(enterprise).to have_many(:answers).through(:questions) }
        it { expect(enterprise).to have_many(:answer_comments).through(:answers).source(:comments) }
        it { expect(enterprise).to have_many(:answer_upvotes).through(:answers).source(:votes) }
        it { expect(enterprise).to have_many(:resources) }
        it { expect(enterprise).to have_many(:yammer_field_mappings) }
        it { expect(enterprise).to have_many(:emails) }
        it { expect(enterprise).to belong_to(:theme) }
        it { expect(enterprise).to have_many(:policy_groups) }
        it { expect(enterprise).to have_many(:expenses) }
        it { expect(enterprise).to have_many(:expense_categories) }
        it { expect(enterprise).to have_many(:biases).through(:users).class_name('Bias') }
        it { expect(enterprise).to have_many(:departments) }
        it { expect(enterprise).to have_many(:rewards) }
        it { expect(enterprise).to have_many(:reward_actions) }
        it { expect(enterprise).to have_many(:badges) }
        it { expect(enterprise).to have_many(:group_categories) }
        it { expect(enterprise).to have_many(:group_category_types) }

        it{ expect(enterprise).to have_one(:custom_text) }

        [:fields, :mobile_fields, :yammer_field_mappings, :theme, :reward_actions].each do |attribute|
            it { expect(enterprise).to accept_nested_attributes_for(attribute).allow_destroy(true) }
        end

        it { expect(enterprise).to validate_presence_of(:cdo_name) }
        it { expect(enterprise).to validate_presence_of(:name) }

        [:cdo_picture, :banner, :xml_sso_config, :sponsor_media, :onboarding_sponsor_media].each do |attribute|
            it { expect(enterprise).to have_attached_file(attribute) }
        end

        it { expect(enterprise).to validate_attachment_content_type(:cdo_picture).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
        it { expect(enterprise).to validate_attachment_content_type(:banner).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
        it { expect(enterprise).to validate_attachment_content_type(:xml_sso_config).allowing('text/xml').rejecting('image/png', 'image/gif') }
    end

    describe 'testing callbacks' do
        let!(:new_enterprise) { build(:enterprise) }

        it 'triggers #create_elasticsearch_only_fields on before_create' do 
            expect(new_enterprise).to receive(:create_elasticsearch_only_fields)
            new_enterprise.save
        end
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
    
    describe "user_group_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :user_group_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("User group mailer notification text can't be blank")
            
            # check for required user name
            enterprise.user_group_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("User group mailer notification text Must include %{user_name}")
            
            # check for required user name
            enterprise.user_group_mailer_notification_text = "%{user_name}"
            expect(enterprise.valid?).to be(true)
        end
    end
    
    describe "campaign_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :campaign_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Campaign mailer notification text can't be blank")
            
            enterprise.campaign_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Campaign mailer notification text Must include %{user_name}, %{campaign_name} and %{join_now}")
            
            enterprise.campaign_mailer_notification_text = "Hello %{user_name},"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Campaign mailer notification text Must include %{user_name}, %{campaign_name} and %{join_now}")
            
            enterprise.campaign_mailer_notification_text = "Hello %{user_name}, The following %{campaign_name} have been invite to campaign"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Campaign mailer notification text Must include %{user_name}, %{campaign_name} and %{join_now}")
            
            enterprise.campaign_mailer_notification_text = "Hello %{user_name}, The following %{campaign_name} have been invite to campaign so %{join_now}"
            expect(enterprise.valid?).to be(true)
        end
    end
    
    describe "approve_budget_request_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :approve_budget_request_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Approve budget request mailer notification text can't be blank")
            
            enterprise.approve_budget_request_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Approve budget request mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.approve_budget_request_mailer_notification_text = "Hello %{user_name},"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Approve budget request mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.approve_budget_request_mailer_notification_text = "Hello %{user_name}, The following %{budget_name} have been invite to campaign"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Approve budget request mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.approve_budget_request_mailer_notification_text = "Hello %{user_name}, The following %{budget_name} have been invite to campaign so %{click_here}"
            expect(enterprise.valid?).to be(true)
        end
    end
    
    describe "poll_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :poll_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Poll mailer notification text can't be blank")
            
            enterprise.poll_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Poll mailer notification text Must include %{user_name}, %{survey_name} and %{click_here}")
            
            enterprise.poll_mailer_notification_text = "Hello %{user_name},"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Poll mailer notification text Must include %{user_name}, %{survey_name} and %{click_here}")
            
            enterprise.poll_mailer_notification_text = "Hello %{user_name}, The following %{survey_name} have been invite to campaign"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Poll mailer notification text Must include %{user_name}, %{survey_name} and %{click_here}")
            
            enterprise.poll_mailer_notification_text = "Hello %{user_name}, The following %{survey_name} have been invite to campaign so %{click_here}"
            expect(enterprise.valid?).to be(true)
        end
    end
    
    describe "budget_approved_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :budget_approved_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget approved mailer notification text can't be blank")
            
            enterprise.budget_approved_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget approved mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.budget_approved_mailer_notification_text = "Hello %{user_name},"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget approved mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.budget_approved_mailer_notification_text = "Hello %{user_name}, The following %{budget_name} have been invite to campaign"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget approved mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.budget_approved_mailer_notification_text = "Hello %{user_name}, The following %{budget_name} have been invite to campaign so %{click_here}"
            expect(enterprise.valid?).to be(true)
        end
    end
    
    describe "budget_declined_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :budget_declined_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget declined mailer notification text can't be blank")
            
            enterprise.budget_declined_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget declined mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.budget_declined_mailer_notification_text = "Hello %{user_name},"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget declined mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.budget_declined_mailer_notification_text = "Hello %{user_name}, The following %{budget_name} have been invite to campaign"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Budget declined mailer notification text Must include %{user_name}, %{budget_name} and %{click_here}")
            
            enterprise.budget_declined_mailer_notification_text = "Hello %{user_name}, The following %{budget_name} have been invite to campaign so %{click_here}"
            expect(enterprise.valid?).to be(true)
        end
    end
    
    describe "group_leader_post_mailer_notification_text" do
        it "is required" do
            enterprise = build(:enterprise, :group_leader_post_mailer_notification_text => nil)
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Group leader post mailer notification text can't be blank")
            
            enterprise.group_leader_post_mailer_notification_text = "wrong text"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Group leader post mailer notification text Must include %{user_name}, %{group_name} and %{click_here}")
            
            enterprise.group_leader_post_mailer_notification_text = "Hello %{user_name},"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Group leader post mailer notification text Must include %{user_name}, %{group_name} and %{click_here}")
            
            enterprise.group_leader_post_mailer_notification_text = "Hello %{user_name}, The following %{group_name} have been invite to campaign"
            expect(enterprise.valid?).to be(false)
            expect(enterprise.errors.full_messages.first).to eq("Group leader post mailer notification text Must include %{user_name}, %{group_name} and %{click_here}")
            
            enterprise.group_leader_post_mailer_notification_text = "Hello %{user_name}, The following %{group_name} have been invite to campaign so %{click_here}"
            expect(enterprise.valid?).to be(true)
        end
    end
end
